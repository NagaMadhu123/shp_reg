/*
collects Aadhar first page and saved as image in firebase storage

and some text fields will be collecting dob, Address (present && permanent)
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test/model/user_model1.dart';
import 'package:test/provider/auth_provider.dart';
import 'package:test/screens/aadhar1_page.dart';
import 'package:test/utils/textfield.dart';
import 'package:test/utils/utils.dart';
import 'package:test/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AddharF extends StatefulWidget {
  const AddharF({super.key});

  @override
  State<AddharF> createState() => _AddharFState();
}

class _AddharFState extends State<AddharF> {
  File? image1;
  final dobController = TextEditingController();
  final addController = TextEditingController();
  final paddController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    dobController.dispose();
    addController.dispose();
    paddController.dispose();
  }

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
                      const Text('please upload aadhar photo (front) here*'),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            // dob here
                            textFeld(
                              hintText: "DD/MM/YYYY",
                              icon: Icons.date_range,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: dobController,
                            ),
                            const Text(
                                '*please enter in DD/MM/YYYY format only'),
                            const SizedBox(
                              height: 20,
                            ),
                            // address here
                            textFeld(
                              hintText: "address",
                              icon: Icons.home,
                              inputType: TextInputType.streetAddress,
                              maxLines: 3,
                              controller: addController,
                            ),
                            const Text(
                                '*please enter address as per aadhar only if not provide the present address'),

                            textFeld(
                              hintText: "address",
                              icon: Icons.home,
                              inputType: TextInputType.streetAddress,
                              maxLines: 3,
                              controller: paddController,
                            ),
                            const Text(
                                '*please enter address as per aadhar only'),
                          ],
                        ),
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
    UserModel1 userModel1 = UserModel1(
      dob: dobController.text.trim(),
      add: addController.text.trim(),
      padd: paddController.text.trim(),
      a1: "",
      uid: "",
    );
    if (image1 != null) {
      ap.saveUserDataToFirebase1(
        context: context,
        userModel1: userModel1,
        a1: image1!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddharS(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your aadhar photo");
    }
  }
}
