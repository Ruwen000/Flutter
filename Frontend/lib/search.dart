// ignore_for_file: non_constant_identifier_names, camel_case_types, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<StatefulWidget> createState() => SearchPage();
}

class SearchPage extends State<search> {
  List<String> docID = [];
  List<Map<String, dynamic>> filteredResults = [];
  CollectionReference users = FirebaseFirestore.instance.collection('Nutzer');
  final user = FirebaseAuth.instance.currentUser!;
  String searchTerm = "";

  Future getDocID() async {
    docID.clear();
    await FirebaseFirestore.instance.collection('Nutzer').get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            docID.add(element.reference.id);
          }),
        );
  }

  void searchUser(String searchTerm) async {
    filteredResults.clear();
    for (var id in docID) {
      var docSnapshot = await users.doc(id).get();
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      if (data['Skill']
          .toString()
          .toLowerCase()
          .contains(searchTerm.toLowerCase())) {
        filteredResults.add(data);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDocID().then((_) {
      searchUser(""); // initially show all users
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(onSearchChanged: (value) {
          setState(() {
            searchTerm = value;
            searchUser(searchTerm);
          });
        }),
        backgroundColor: Colors.teal,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: filteredResults.isEmpty
                ? const Center(
                    child: Text("Keine Ergebnisse gefunden"),
                  )
                : ListView.builder(
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = filteredResults[index];

                      return Card(
                        elevation: 4,
                        color: Colors.teal[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                            'Name: ${data['name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                          subtitle: Text(
                            'Skill: ${data['skill']}',
                            style: TextStyle(color: Colors.teal[600]),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.teal),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      title: Text('Name: ${data['name']}'),
                                      backgroundColor: Colors.teal,
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
                                            'Name: ${data['name']}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Skill: ${data['skill']}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.teal[600],
                                            ),
                                          ),
                                          Text(
                                            'Wohnort: ${data['ort']}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.teal[700],
                                            ),
                                          ),
                                          Text(
                                            'Email Adresse: ${data['email']}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.teal[700],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              addDetails(
                                                  data['email'], user.email!);
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.teal,
                                            ),
                                            child: const Text('Deal Anfrage'),
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
                    },
                  ),
          ),
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
  final Function(String) onSearchChanged;

  const SearchBar({required this.onSearchChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Suche...',
        border: InputBorder.none,
        icon: Icon(Icons.search, color: Colors.white),
      ),
      onChanged: onSearchChanged,
    );
  }
}
