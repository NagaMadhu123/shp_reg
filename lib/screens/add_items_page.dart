import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test/model/user_model6.dart';
import 'package:test/provider/auth_provider.dart';
import 'package:test/screens/shop_page.dart';
import 'package:test/screens/view_items1.dart';
import 'package:test/utils/textfield.dart';
import 'package:test/utils/utils.dart';
import 'package:test/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  File? image6;
  final nameController = TextEditingController();
  final costController = TextEditingController();
  final catController = TextEditingController();
  final weightController = TextEditingController();
  final nopController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    costController.dispose();
    catController.dispose();
    nopController.dispose();
    weightController.dispose();
  }

  // for selecting image6
  void selectimage() async {
    image6 = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Enter New Shop"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShopPage(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
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
                        'Enter Item Details',
                        style: TextStyle(fontSize: 28, color: Colors.purple),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => selectimage(),
                        child: image6 == null
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
                                backgroundImage: FileImage(image6!),
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
                            //item name
                            textFeld(
                              hintText: "item name",
                              icon: Icons.comment_bank,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: nameController,
                            ),
                            //item catageory
                            textFeld(
                              hintText: "catageory of item",
                              icon: Icons.merge_type,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: catController,
                            ),
                            //item cost
                            textFeld(
                              hintText: "cost",
                              icon: Icons.currency_rupee_sharp,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: costController,
                            ),

                            //item weight
                            textFeld(
                              hintText: "weight of item",
                              icon: Icons.balance,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: weightController,
                            ),
                            //no of piece
                            textFeld(
                              hintText:
                                  "No.of pieces (if not by weight mention)",
                              icon: Icons.online_prediction,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: nopController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Add Item",
                          onPressed: () => storeData(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "please do",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewItems1(),
                              ),
                            );
                          },
                        ),
                      ),
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
    UserModel6 userModel6 = UserModel6(
      itemName: nameController.text.trim(),
      itemCost: costController.text.trim(),
      itemCat: catController.text.trim(),
      weight: weightController.text.trim(),
      nop: nopController.text.trim(),
      itemImage: "",
      uid: "",
      date: "",
    );
    if (image6 != null) {
      ap.saveUserDataToFirebase6(
        context: context,
        userModel6: userModel6,
        itemImage: image6!,
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
    } else {
      showSnackBar(context, "Please upload Item photo");
    }
  }

  pickimage(BuildContext context) {}
}
