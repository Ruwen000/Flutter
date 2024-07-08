import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<Profil> {
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('Nutzer');
  CollectionReference bilder = FirebaseFirestore.instance.collection('Bilder');
  File? _profileImage;
  late String _profileImageUrl;
  String? _skill;

  Future<List<DocumentSnapshot>> getUserData() async {
    try {
      String email = user.email!;
      String emailFirstUpperCase = email[0].toUpperCase() + email.substring(1);
      String emailFirstLowerCase = email[0].toLowerCase() + email.substring(1);

      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: emailFirstUpperCase).get();

      QuerySnapshot querySnapshotLowerCase =
          await users.where('email', isEqualTo: emailFirstLowerCase).get();

      List<DocumentSnapshot> combinedResults = [
        ...querySnapshot.docs,
        ...querySnapshotLowerCase.docs,
      ];

      final uniqueResults = {for (var doc in combinedResults) doc.id: doc};

      return uniqueResults.values.toList();
    } catch (e) {
      print('Fehler beim Abrufen der Benutzerdaten: $e');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _profileImageUrl = ''; // Initialisierung hinzugefügt
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('bilder')
          .doc(user.email)
          .get();
      if (userDoc.exists) {
        setState(() {
          _profileImageUrl = userDoc['profileImageUrl'] ?? '';
        });
      }
    } catch (e) {
      print('Fehler beim Laden des Profilbildes: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _uploadProfileImage();
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.email}.jpg'); // Use email as filename

      await ref.putFile(_profileImage!);
      final url = await ref.getDownloadURL();
      setState(() {
        _profileImageUrl = url;
      });
      await FirebaseFirestore.instance.collection('bilder').doc(user.email).set(
          {'profileImageUrl': url},
          SetOptions(merge: true)); // Use email as document ID
    } catch (e) {
      print('Fehler beim Hochladen des Bildes: $e');
    }
  }

  Future<void> _editSkill() async {
    TextEditingController skillController = TextEditingController(text: _skill);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Skill bearbeiten',
            style: TextStyle(color: Color.fromARGB(255, 172, 185, 255)),
          ),
          content: TextField(
            controller: skillController,
            decoration: const InputDecoration(
              hintText: "Neuer Skill",
              hintStyle: TextStyle(color: Color.fromARGB(255, 172, 185, 255)),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 172, 185, 255)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            style: const TextStyle(color: Color.fromARGB(255, 172, 185, 255)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Abbrechen',
                style: TextStyle(color: Color.fromARGB(255, 172, 185, 255)),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newSkill = skillController.text.trim();
                if (newSkill.isNotEmpty) {
                  try {
                    QuerySnapshot querySnapshot =
                        await users.where('email', isEqualTo: user.email).get();

                    if (querySnapshot.docs.isNotEmpty) {
                      DocumentSnapshot userDoc = querySnapshot.docs.first;
                      await users.doc(userDoc.id).update({'skill': newSkill});
                      setState(() {
                        _skill = newSkill;
                      });
                    }
                  } catch (e) {
                    print('Fehler beim Aktualisieren des Skills: $e');
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Speichern',
                style: TextStyle(color: Color.fromARGB(255, 159, 173, 253)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Mein Profil',
          style: TextStyle(
            color: Color.fromARGB(255, 92, 150, 226),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: signOut,
          ),
        ],
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _editSkill,
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget buildBody() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 70,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : (_profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                          : const NetworkImage('https://picsum.photos/200'))
                      as ImageProvider,
              child: const Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 20,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 40, thickness: 1.5, indent: 20, endIndent: 20),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "laden...",
                    style: TextStyle(color: Color.fromARGB(255, 131, 180, 255)),
                  );
                } else if (snapshot.hasError) {
                  print('Fehler beim Laden der Daten: ${snapshot.error}');
                  return const Text('Fehler beim Laden der Daten');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Keine Daten gefunden');
                } else {
                  Map<String, dynamic> data =
                      snapshot.data!.first.data() as Map<String, dynamic>;
                  _skill = data['skill'];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileDetail(
                            title: 'Name', detail: data['name'] ?? ''),
                        ProfileDetail(
                            title: 'Wohnort', detail: data['ort'] ?? ''),
                        ProfileDetail(
                            title: 'Email Adresse',
                            detail: data['email'] ?? ''),
                        const Divider(
                            height: 40,
                            thickness: 1.5,
                            indent: 20,
                            endIndent: 20),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Dein Skill:',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      10), // Abstand zwischen Text und Skill
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 20,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _skill ?? 'Kein Skill angegeben',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

class ProfileDetail extends StatelessWidget {
  final String title;
  final String detail;

  const ProfileDetail({required this.title, required this.detail, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            size: 10,
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              detail,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
