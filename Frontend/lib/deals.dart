// ignore_for_file: camel_case_types, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class deals extends StatefulWidget {
  const deals({super.key});

  @override
  State<StatefulWidget> createState() => dealspage();
}

class dealspage extends State<deals> {
  List<String> docID = [];
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users =
      FirebaseFirestore.instance.collection('LaufendeDeals');

  Future getDocID() async {
    docID.clear();
    await FirebaseFirestore.instance.collection('LaufendeDeals').get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            docID.add(element.reference.id);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: getDocID(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: docID.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: users.doc(docID[index]).get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                if (user.email! == data['Nehmer'] ||
                                    user.email! == data['dealer']) {
                                  return Card(
                                    child: ListTile(
                                      title: Text('Name:  ${data['Nehmer']}'),
                                      subtitle:
                                          Text('Name2:  ${data['dealer']}'),
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(builder:
                                                (BuildContext context) {
                                              return Scaffold(
                                                appBar: AppBar(
                                                  title: const Text('Anfrage'),
                                                ),
                                                body: Center(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          'Laufender deal mit${data['dealer']} '),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        });
                                      },
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              } else {
                                return const Text('Loading...');
                              }
                            },
                          );
                        });
                  })),
        ],
      ),
    );
  }
}
