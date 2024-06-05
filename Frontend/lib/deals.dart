// ignore_for_file: camel_case_types, avoid_function_literals_in_foreach_calls
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class deals extends StatefulWidget {
  const deals({Key? key});

  @override
  State<StatefulWidget> createState() => DealsPage();
}

class DealsPage extends State<deals> {
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('LaufendeDeals');
  List<String> docID = [];

  @override
  void initState() {
    super.initState();
    getDocID(); // Daten laden, wenn die Seite initialisiert wird
  }

  Future<void> getDocID() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('LaufendeDeals').get();
    setState(() {
      docID = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: docID
              .isEmpty // Überprüfe, ob die Liste leer ist, bevor du sie zeigst
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: docID.length,
              itemBuilder: (context, index) {
                return FutureBuilder<DocumentSnapshot>(
                  future: users.doc(docID[index]).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      if (user.email! == data['Nehmer'] ||
                          user.email! == data['dealer']) {
                        return Card(
                          elevation:
                              4, // Erhöht die Kartenhöhe für einen Schatten-Effekt
                          color: Colors.teal[50], // Hintergrundfarbe der Karte
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Abgerundete Ecken für die Karte
                          ),
                          child: ListTile(
                            leading: const Icon(Icons
                                .assignment), // Ein passendes Icon auf der linken Seite
                            title: Text('Name: ${data['Nehmer']}'),
                            subtitle: Text('Name2: ${data['dealer']}'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        title: const Text('Anfrage'),
                                        backgroundColor: Colors.teal,
                                      ),
                                      body: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                'Laufender Deal mit ${data['dealer']}'),
                                            // Hier können weitere Details oder Aktionen hinzugefügt werden
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      return const SizedBox(
                        height: 50.0,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
