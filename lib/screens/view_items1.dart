import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewItems1 extends StatelessWidget {
  const ViewItems1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("These are the items uploaded"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('items')
            .orderBy("uid")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(25),
            children: snapshot.data!.docs.map((document) {
              return Center(
                child: Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  '${'${"Name:" ' ' + document["itemName"] + '\n' + 'rs:' + ' ' + document['itemCost'] + '\t' + '  no.Pc.' + document['nop'] + '\n' + document['date']}\nuid: ' + document['uid']}\n',

                  style: const TextStyle(
                      fontSize: 39, fontWeight: FontWeight.w400),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
