import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class anfragen extends StatefulWidget {
  const anfragen({super.key});

  @override
  State<StatefulWidget> createState() => AnfragenPage();
}

class AnfragenPage extends State<anfragen> {
  List<String> docID = [];
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference dealsCollection =
      FirebaseFirestore.instance.collection('Deals');
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Nutzer');

  Future<void> getDocID() async {
    docID.clear();
    await dealsCollection.get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            docID.add(element.reference.id);
          }),
        );
  }

  Future<void> addDetails(String name1, String name2) async {
    await FirebaseFirestore.instance.collection('LaufendeDeals').add({
      'Nehmer': name1,
      'dealer': name2,
    });
  }

  Future<void> deleteDetails(String documentId) async {
    try {
      await dealsCollection.doc(documentId).delete();
      print('Dokument erfolgreich gelöscht');
    } catch (e) {
      print('Fehler beim Löschen des Dokuments: $e');
    }
  }

  Future<String> getDealerSkill(String dealerEmail) async {
    try {
      QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: dealerEmail).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['skill'];
      } else {
        return 'Skill nicht gefunden';
      }
    } catch (e) {
      print('Fehler beim Abrufen des Skills: $e');
      return 'Fehler beim Abrufen des Skills';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: getDocID(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else {
                  final bool hasRequests = docID.isNotEmpty;
                  return hasRequests
                      ? ListView.builder(
                          itemCount: docID.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: dealsCollection.doc(docID[index]).get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  if (user.email! == data['Nehmer']) {
                                    return FutureBuilder<String>(
                                      future: getDealerSkill(data['dealer']),
                                      builder: (context, skillSnapshot) {
                                        if (skillSnapshot.connectionState ==
                                            ConnectionState.done) {
                                          String dealerSkill =
                                              skillSnapshot.data ??
                                                  'Skill nicht gefunden';
                                          return Card(
                                            elevation: 4,
                                            color: Colors.blue[50],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ListTile(
                                              leading:
                                                  const Icon(Icons.assignment),
                                              title: Text('${data['dealer']}'),
                                              subtitle: const Text(
                                                  'Will einen Deal mit dir eingehen'),
                                              onTap: () {
                                                setState(() {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute<void>(
                                                      builder: (BuildContext
                                                          context) {
                                                        return Scaffold(
                                                          backgroundColor:
                                                              Colors.black,
                                                          appBar: AppBar(
                                                            title: const Text(
                                                                'Anfrage'),
                                                            backgroundColor:
                                                                Colors
                                                                    .blue[900],
                                                            centerTitle: true,
                                                          ),
                                                          body: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          20),
                                                                  child: Text(
                                                                    'Willst du die Anfrage von ${data['dealer']} annehmen? \nSein Skill:  \n- $dealerSkill -',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          136,
                                                                          157,
                                                                          250),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                SizedBox(
                                                                  width: 200,
                                                                  height: 40,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      addDetails(
                                                                          data[
                                                                              'dealer'],
                                                                          user.email!);
                                                                      deleteDetails(
                                                                          docID[
                                                                              index]);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .blue[900],
                                                                    ),
                                                                    child: const Text(
                                                                        'Deal Annehmen?'),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                SizedBox(
                                                                  width: 200,
                                                                  height: 40,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      deleteDetails(
                                                                          docID[
                                                                              index]);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                    ),
                                                                    child: const Text(
                                                                        'Anfrage Ablehnen'),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                });
                                              },
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            );
                          },
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 50),
                              Text("Keine Anfragen",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 131, 180, 255))),
                            ],
                          ),
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
