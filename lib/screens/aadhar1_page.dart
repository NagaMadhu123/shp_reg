/*
collects Aadhar second page and saved as image in firebase storage
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test/model/user_model2.dart';
import 'package:test/provider/auth_provider.dart';
import 'package:test/utils/utils.dart';
import 'package:test/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import 'pan_page.dart';

class AddharS extends StatefulWidget {
  const AddharS({super.key});

  @override
  State<AddharS> createState() => _AddharSState();
}

class _AddharSState extends State<AddharS> {
  File? image1;

  // for selecting image
  void selectImage() async {
    image1 = await pickImage(context);
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
                        'please enter Aadhar details',
                        style: TextStyle(fontSize: 28, color: Colors.purple),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => selectImage(),
                        child: image1 == null
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
                                backgroundImage: FileImage(image1!),
                                radius: 50,
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('please upload aadhar photo(back) here*'),
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
    UserModel2 userModel2 = UserModel2(
      a2: "",
      uid: "",
    );
    if (image1 != null) {
      ap.saveUserDataToFirebase2(
        context: context,
        userModel2: userModel2,
        a2: image1!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PanUpload(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your aadhar back side photo");
    }
  }
}
