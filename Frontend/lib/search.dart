// ignore_for_file: non_constant_identifier_names, camel_case_types, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<StatefulWidget> createState() => searchpage();
}

class searchpage extends State<search> {
  List<String> docID = [];
  CollectionReference users = FirebaseFirestore.instance.collection('Nutzer');
  final user = FirebaseAuth.instance.currentUser!;

  Future getDocID() async {
    docID.clear();
    await FirebaseFirestore.instance.collection('Nutzer').get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            docID.add(element.reference.id);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SearchBar(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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

                                return Card(
                                  child: ListTile(
                                    title: Text('Name:  ${data['name']}'),
                                    subtitle: Text('Skill:  ${data['Skill']}'),
                                    onTap: () {
                                      setState(() {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                              builder: (BuildContext context) {
                                            return Scaffold(
                                              appBar: AppBar(
                                                title: Text(
                                                    'Name: ${data['name']}'),
                                              ),
                                              body: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          'https://picsum.photos/100'),
                                                      radius: 70,
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Text(
                                                        'Name: ${data['name']}'),
                                                    Text(
                                                        'Skill: ${data['Skill']}'),
                                                    Text(
                                                        'Wohnort: ${data['ort']}'),
                                                    Text(
                                                        'Email Adresse: ${data['email']}'),
                                                    const SizedBox(height: 20),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        addDetails(
                                                            data['email'],
                                                            user.email!);
                                                      },
                                                      child: const Text(
                                                          'Deal Anfrage'),
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

Future addDetails(String name1, String name2) async {
  await FirebaseFirestore.instance.collection('Deals').add({
    'Nehmer': name1,
    'dealer': name2,
  });
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText:
            'Suche...', // Text, der erscheint, wenn keine Eingabe erfolgt ist
        border: InputBorder.none,
        icon: Icon(
            Icons.search), // Ein Suchsymbol auf der linken Seite der Suchleiste
      ),
      onChanged: (value) {
        // Hier kannst du Logik einfügen, die bei jeder Änderung im Suchfeld ausgeführt wird
        print('Suchbegriff: $value');
      },
    );
  }
}
