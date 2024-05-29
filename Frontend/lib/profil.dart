import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/kontodaten.dart';
import 'dart:convert';

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
    await FirebaseFirestore.instance.collection('Nutzer').get().then(
          (snapshot) => snapshot.docs.forEach((element) {
            docID.add(element.reference.id);
          }),
        );
  }

  Future<List<kontodaten>> fetchKonto() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/konten'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => kontodaten.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  final user = FirebaseAuth.instance.currentUser!;

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
              child: FutureBuilder<List<kontodaten>>(
                future: fetchKonto(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Data Found'));
                  } else {
                    List<kontodaten> data = snapshot.data!;
                    for (int i = 0; i < data.length; i++) {
                      if (user.email! == data[i].email) {
                        return Column(
                          children: [
                            Text(data[i].name),
                            Text(data[i].email),
                            Text(data[i].Ort),
                            ...data[i].skill.map((skill) => Text(skill)),
                          ],
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void signOut() {
  FirebaseAuth.instance.signOut();
}
