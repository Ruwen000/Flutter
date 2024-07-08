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
  late String dealer = 'Nehmer';

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

  Future<void> deleteDeal(String docId) async {
    await FirebaseFirestore.instance
        .collection('LaufendeDeals')
        .doc(docId)
        .delete();
    getDocID(); // Aktualisiere die Liste der Deals nach dem Löschen
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: docID.isEmpty
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
                        if (user.email! == data['Nehmer']) {
                          dealer = 'dealer';
                        }
                        return Card(
                          elevation: 4,
                          color: Colors.blue[50], // Hintergrundfarbe der Karte
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.assignment),
                            title: Text('${data[dealer]}'),
                            subtitle: const Text('Hat ein Deal mit dir!'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      backgroundColor: Colors.black,
                                      appBar: AppBar(
                                        title: const Text(
                                          'Dein Deal',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 158, 192, 243),
                                          ),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                            255,
                                            18,
                                            47,
                                            173), // Farbe der AppBar
                                      ),
                                      body: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Dein Deal',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 139, 166, 255),
                                              ),
                                            ),
                                            Text(
                                              'Schreib ${data['Nehmer']} doch an!',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 139, 166, 255),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .red, // Hintergrundfarbe des Buttons
                                              ),
                                              onPressed: () async {
                                                await deleteDeal(docID[index]);
                                                Navigator.of(context)
                                                    .pop(); // Zurück zur vorherigen Seite
                                              },
                                              child: const Text(
                                                'Deal beenden',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                            ),
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
