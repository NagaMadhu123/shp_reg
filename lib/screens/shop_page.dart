/*

collects shop details

and allows user to upload all items available.


next page ==> view_items.dart

 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test/provider/auth_provider.dart';
import 'package:test/screens/add_items_page.dart';
import 'package:test/utils/textfield.dart';
import 'package:test/utils/utils.dart';
import 'package:test/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:test/model/user_model5.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  File? image5;
  final snameController = TextEditingController();
  final stypeController = TextEditingController();
  final supiController = TextEditingController();
  final sphnController = TextEditingController();
  final slocController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    snameController.dispose();
    stypeController.dispose();
    supiController.dispose();
    sphnController.dispose();
    slocController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image5 = await pickImage(context);
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
                        'please upload Shop Details',
                        style: TextStyle(fontSize: 28, color: Colors.purple),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => selectImage(),
                        child: image5 == null
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
                                backgroundImage: FileImage(image5!),
                                radius: 50,
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('please Upload shop photo*'),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            //Shop Name
                            textFeld(
                              hintText: "Shop name",
                              icon: Icons.comment_bank,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: snameController,
                            ),

                            //type
                            textFeld(
                              hintText: "Type",
                              icon: Icons.contact_page,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: stypeController,
                            ),
                            //upi ID
                            textFeld(
                              hintText: "Shop UPI id",
                              icon: Icons.currency_rupee,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: supiController,
                            ),
                            //phone number of shop
                            textFeld(
                              hintText: "Enter shop phone number",
                              icon: Icons.phone,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: sphnController,
                            ),
                            //to enter url of shop from google maps
                            textFeld(
                              hintText: "Google map link of shop",
                              icon: Icons.map,
                              inputType: TextInputType.url,
                              maxLines: 2,
                              controller: slocController,
                            ),
                            const Text(
                                'please enter current location link from google maps while standing near the store which you are uploading'),
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
    UserModel5 userModel5 = UserModel5(
      sname: snameController.text.trim(),
      type: stypeController.text.trim(),
      supi: supiController.text.trim(),
      sphn: sphnController.text.trim(),
      loc: slocController.text.trim(),
      simg: "",
      agent: "",
    );
    if (image5 != null) {
      ap.saveUserDataToFirebase5(
        context: context,
        userModel5: userModel5,
        simg: image5!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewPage(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
      showSnackBar(context, 'shop data uploaded sucessfully');
    } else {
      showSnackBar(context, "Please upload Shop photo");
    }
  }
}
