// ignore_for_file: camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class firebasedata extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String ID;

  // ignore: non_constant_identifier_names
  const firebasedata({super.key, required this.ID});

  @override
  // ignore: library_private_types_in_public_api
  _firebasedataState createState() => _firebasedataState();
}

class _firebasedataState extends State<firebasedata> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Nutzer');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.ID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['email'] == user.email!) {
            return Column(
              children: [
                Text('Name:  ${data['name']}'),
                Text('Email:  ${data['email']}'),
                Text('Wohnort:  ${data['ort']}'),
                Text('Skill:  ${data['skill']}')
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const Text('Loading...');
        }
      },
    );
  }
}
