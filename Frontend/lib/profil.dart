// ignore_for_file: camel_case_types, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profil extends StatefulWidget {
  const profil({super.key});

  @override
  State<StatefulWidget> createState() => profilpage();
}

class profilpage extends State<profil> {
  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  List<String> docID = [];

  Future getDocID() async {
    docID.clear();
    await FirebaseFirestore.instance.collection('Nutzer').get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            docID.add(element.reference.id);
          }),
        );
  }

  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('Nutzer');

  Widget buildBody() {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Profil"),
            Text(user.email!),
            const CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/100'),
              radius: 70,
            ),
            const Divider(),
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
                                  if (data['email'] == user.email!) {
                                    return ListTile(
                                      title: Text('Name:  ${data['name']}'),
                                      subtitle:
                                          Text('Skill:  ${data['Skill']}'),
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
      ),
    );
  }
}

void signOut() {
  FirebaseAuth.instance.signOut();
}
