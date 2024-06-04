// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class anfragen extends StatefulWidget {
  const anfragen({super.key});

  @override
  State<StatefulWidget> createState() => anfragenpage();
}

class anfragenpage extends State<anfragen> {
  List<String> docID = [];
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('Deals');

  Future getDocID() async {
    docID.clear();
    await FirebaseFirestore.instance.collection('Deals').get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            docID.add(element.reference.id);
          }),
        );
  }

  Future addDetails(String name1, String name2) async {
    await FirebaseFirestore.instance.collection('LaufendeDeals').add({
      'Nehmer': name1,
      'dealer': name2,
    });
  }

  Future<void> deleteDetails(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Deals')
          .doc(documentId)
          .delete();
      print('Dokument erfolgreich gelöscht');
    } catch (e) {
      print('Fehler beim Löschen des Dokuments: $e');
    }
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
                                if (user.email! == data['Nehmer']) {
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
                                                          'Willst du die Anfrage von ${data['dealer']} annehmen?'),
                                                      const SizedBox(
                                                          height: 20),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          addDetails(
                                                              data['dealer'],
                                                              user.email!);
                                                          deleteDetails(
                                                              docID[index]);
                                                        },
                                                        child: const Text(
                                                            'Deal Annehmen?'),
                                                      ),
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
                                  return const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 50),
                                        Text("Keine Anfragen"),
                                        Icon(Icons.search),
                                      ],
                                    ),
                                  );
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
