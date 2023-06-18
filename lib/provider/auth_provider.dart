// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:test/model/user_model.dart';
import 'package:test/model/user_model1.dart';
import 'package:test/model/user_model2.dart';
import 'package:test/model/user_model3.dart';
import 'package:test/model/user_model4.dart';
import 'package:test/model/user_model5.dart';
import 'package:test/model/user_model6.dart';
import 'package:test/screens/otp_screen.dart';
import 'package:test/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

  String? _sphn;
  String get sphn => _sphn!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  UserModel1? _userModel1;
  UserModel1 get userModel1 => _userModel1!;

  UserModel2? _userModel2;
  UserModel2 get userModel2 => _userModel2!;

  UserModel3? _userModel3;
  UserModel3 get userModel3 => _userModel3!;

  UserModel4? _userModel4;
  UserModel4 get userModel4 => _userModel4!;

  UserModel5? _userModel5;
  UserModel5 get userModel5 => _userModel5!;

  UserModel6? _userModel6;
  UserModel6 get userModel6 => _userModel6!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // signin
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        // carry our logic
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPERTAIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

// to save user data to firebase database
  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _userModel = userModel;

      // uploading to database
      await _firebaseFirestore
          .collection("Store Agents")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("Store Agents")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        email: snapshot['email'],
        createdAt: snapshot['createdAt'],
        bio: snapshot['bio'],
        uid: snapshot['uid'],
        profilePic: snapshot['profilePic'],
        phoneNumber: snapshot['phoneNumber'],
      );
      _uid = userModel.uid;
    });
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';

    _userModel = UserModel.fromMap(jsonDecode(data));

    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

  //to store aadhar 1st page

  void saveUserDataToFirebase1({
    required BuildContext context,
    required UserModel1 userModel1,
    required File a1,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("a1/$_uid", a1).then((value) {
        userModel1.a1 = value;
        userModel1.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _userModel1 = userModel1;

      // uploading to database
      await _firebaseFirestore
          .collection("SA aadhar")
          .doc(_uid)
          .set(userModel1.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  //to store aadhar 2nd page

  void saveUserDataToFirebase2({
    required BuildContext context,
    required UserModel2 userModel2,
    required File a2,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("a2/$_uid", a2).then((value) {
        userModel2.a2 = value;
        userModel2.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _userModel2 = userModel2;

      // uploading to database
      await _firebaseFirestore
          .collection("SA aadhar1")
          .doc(_uid)
          .set(userModel2.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  //to upload pan page

  void saveUserDataToFirebase3({
    required BuildContext context,
    required UserModel3 userModel3,
    required File p1,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("p1/$_uid", p1).then((value) {
        userModel3.p1 = value;
        userModel3.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _userModel3 = userModel3;

      // uploading to database
      await _firebaseFirestore
          .collection("SA Pan")
          .doc(_uid)
          .set(userModel3.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  //to upload bank deatils

  void saveUserDataToFirebase4({
    required BuildContext context,
    required UserModel4 userModel4,
    required File bankstmt,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("bankstmt/$_uid", bankstmt).then((value) {
        userModel4.bankstmt = value;
        userModel4.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _userModel4 = userModel4;

      // uploading to database
      await _firebaseFirestore
          .collection("SA Bank Details")
          .doc(_uid)
          .set(userModel4.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  //to upload shop page data

  void saveUserDataToFirebase5({
    required BuildContext context,
    required UserModel5 userModel5,
    required File simg,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("simg", simg).then((value) {
        userModel5.simg = value;
        userModel5.agent = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _userModel5 = userModel5;

      // uploading to database
      await _firebaseFirestore
          .collection("Stores")
          .doc()
          .set(userModel5.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  //to upload items

  void saveUserDataToFirebase6({
    required BuildContext context,
    required UserModel6 userModel6,
    required File itemImage,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("itemImage/$_sphn", itemImage).then((value) {
        userModel6.itemImage = value;
        userModel6.uid = userModel5.sphn;
        userModel6.date = DateTime.now().toString();
      });
      _userModel6 = userModel6;

      // uploading to database
      await _firebaseFirestore
          .collection("Stores")
          .doc(userModel5.sphn)
          .collection("items")
          .doc()
          .set(userModel6.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}
