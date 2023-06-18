/*
this page will collect pan image and stored in firebase storage
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test/model/user_model3.dart';
import 'package:test/provider/auth_provider.dart';
import 'package:test/screens/bank_details.dart';
import 'package:test/utils/utils.dart';
import 'package:test/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class PanUpload extends StatefulWidget {
  const PanUpload({super.key});

  @override
  State<PanUpload> createState() => _PanUploadState();
}

class _PanUploadState extends State<PanUpload> {
  File? image2;

  // for selecting image
  void selectImage() async {
    image2 = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'please upload PAN card',
                        style: TextStyle(fontSize: 28, color: Colors.purple),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () => selectImage(),
                        child: image2 == null
                            ? const CircleAvatar(
                                backgroundColor: Colors.purple,
                                radius: 50,
                                child: Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(image2!),
                                radius: 50,
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('please upload PAN card here*'),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Continue",
                          onPressed: () => storeData(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // store user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel3 userModel3 = UserModel3(
      p1: "",
      uid: "",
    );
    if (image2 != null) {
      ap.saveUserDataToFirebase3(
        context: context,
        userModel3: userModel3,
        p1: image2!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BankDetails(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your Pan card photo");
    }
  }
}
