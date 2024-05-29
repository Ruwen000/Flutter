import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class firebasedata extends StatefulWidget {
  final String ID;

  firebasedata({required this.ID});

  @override
  _firebasedataState createState() => _firebasedataState();
}

class _firebasedataState extends State<firebasedata> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Nutzer');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.ID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              Text('Name:  ${data['name']}'),
            ],
          );
        } else {
          return const Text('Loading...');
        }
      },
    );
  }
}
