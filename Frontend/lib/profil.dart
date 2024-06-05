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

  Future<List<DocumentSnapshot>> getUserData() async {
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: user.email).get();
    return querySnapshot.docs;
  }

  @override
  void initState() {
    super.initState();
    _profileImageUrl = ''; // Initialisierung hinzugefügt
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    DocumentSnapshot userDoc = await bilder.doc(user.uid).get();
    if (userDoc.exists) {
      setState(() {
        _profileImageUrl = userDoc['profileImageUrl'] ?? '';
      });
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
          .child(user.uid + '.jpg');

      await ref.putFile(_profileImage!);
      final url = await ref.getDownloadURL();
      setState(() {
        _profileImageUrl = url;
      });
      await bilder
          .doc(user.uid)
          .set({'profileImageUrl': url}, SetOptions(merge: true));
    } catch (e) {
      print('Fehler beim Hochladen des Bildes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Profil'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          )
        ],
      ),
      body: buildBody(),
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
                  // ignore: unnecessary_null_comparison
                  : (_profileImageUrl != null && _profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                          : const NetworkImage('https://picsum.photos/200'))
                      as ImageProvider,
              child: const Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  backgroundColor: Colors.teal,
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
          const SizedBox(height: 10),
          Text(
            user.email!,
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 40, thickness: 1.5, indent: 20, endIndent: 20),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else if (snapshot.hasError) {
                  return const Text('Fehler beim Laden der Daten');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Keine Daten gefunden');
                } else {
                  Map<String, dynamic> data =
                      snapshot.data!.first.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileDetail(
                            title: 'Name', detail: data['name'] ?? ''),
                        ProfileDetail(
                            title: 'Skill', detail: data['skill'] ?? ''),
                        ProfileDetail(
                            title: 'Wohnort', detail: data['ort'] ?? ''),
                        ProfileDetail(
                            title: 'Email Adresse',
                            detail: data['email'] ?? ''),
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
            color: Colors.teal,
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              detail,
              style: TextStyle(
                color: Colors.teal[600],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
