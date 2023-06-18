/*
collects Bank first page image 
bank details are collected
and saved in firebase storage
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test/model/user_model4.dart';
import 'package:test/provider/auth_provider.dart';
import 'package:test/screens/home_screen.dart';
import 'package:test/utils/textfield.dart';
import 'package:test/utils/utils.dart';
import 'package:test/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  File? image4;
  final bnameController = TextEditingController();
  final branchController = TextEditingController();
  final accnoController = TextEditingController();
  final ifscController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    bnameController.dispose();
    branchController.dispose();
    accnoController.dispose();
    ifscController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image4 = await pickImage(context);
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
                        'please enter Bank details',
                        style: TextStyle(fontSize: 28, color: Colors.purple),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => selectImage(),
                        child: image4 == null
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
                                backgroundImage: FileImage(image4!),
                                radius: 50,
                              ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            //bank name
                            textFeld(
                              hintText: "bank name",
                              icon: Icons.comment_bank,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: bnameController,
                            ),

                            //branch
                            textFeld(
                              hintText: "branch",
                              icon: Icons.location_city,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: branchController,
                            ),
                            //account number
                            textFeld(
                              hintText: "account number",
                              icon: Icons.account_tree,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: accnoController,
                            ),
                            //ifsc
                            textFeld(
                              hintText: "IFSC code",
                              icon: Icons.code,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: ifscController,
                            ),
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
    UserModel4 userModel4 = UserModel4(
      bankname: bnameController.text.trim(),
      branch: branchController.text.trim(),
      accountnumber: accnoController.text.trim(),
      ifsc: branchController.text.trim(),
      bankstmt: "",
      uid: "",
    );
    if (image4 != null) {
      ap.saveUserDataToFirebase4(
        context: context,
        userModel4: userModel4,
        bankstmt: image4!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your BANK FIRST PAGE photo");
    }
  }
}
