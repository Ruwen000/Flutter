import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class search extends StatefulWidget {
  const search({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<search> {
  List<String> docIDs = [];
  List<Map<String, dynamic>> filteredResults = [];
  CollectionReference users = FirebaseFirestore.instance.collection('Nutzer');
  final user = FirebaseAuth.instance.currentUser!;
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    getDocIDs().then((_) {
      searchUser(""); // Initially show all users
    });
  }

  Future<void> getDocIDs() async {
    try {
      docIDs.clear();
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Nutzer').get();
      for (var element in snapshot.docs) {
        docIDs.add(element.reference.id);
      }
    } catch (e) {
      // Handle error
      print("Error fetching document IDs: $e");
    }
  }

  void searchUser(String searchTerm) async {
    try {
      QuerySnapshot querySnapshot = await users
          .where('skill', isGreaterThanOrEqualTo: searchTerm)
          .where('skill', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .get();
      filteredResults = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      setState(() {});
    } catch (e) {
      // Handle error
      print("Error searching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: SearchBar(
          onSearchChanged: (value) {
            setState(() {
              searchTerm = value;
              searchUser(searchTerm);
            });
          },
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (filteredResults.isEmpty && searchTerm.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Column(
        children: [
          Expanded(
            child: filteredResults.isEmpty
                ? const Center(
                    child: Text(
                      "Keine Ergebnisse gefunden",
                      style: TextStyle(
                        color: Color.fromARGB(255, 131, 180, 255),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = filteredResults[index];
                      return Card(
                        elevation: 4,
                        color: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: ProfileAvatar(email: data['email'], a: 0),
                          title: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.blue[900],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${data['skill']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'Name: ${data['name']}',
                            style: TextStyle(
                              color: Colors.blue[800],
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromARGB(255, 13, 71, 158),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    backgroundColor: Colors.black,
                                    appBar: AppBar(
                                      title: Text(
                                        'Name: ${data['name']}',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 158, 192, 243),
                                        ),
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 18, 47, 173),
                                    ),
                                    body: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ProfileAvatar(
                                              email: data['email'], a: 1),
                                          const SizedBox(height: 20),
                                          Text(
                                            'Skill: ${data['skill']}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 131, 180, 255),
                                            ),
                                          ),
                                          Text(
                                            'Wohnort: ${data['ort']}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blue[900],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              addDetails(
                                                data['email'],
                                                user.email!,
                                              );
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue[900],
                                            ),
                                            child: const Text(
                                              'Deal Anfrage',
                                              style: TextStyle(
                                                color: Colors.white,
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
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

Future<void> addDetails(String name1, String name2) async {
  await FirebaseFirestore.instance.collection('Deals').add({
    'Nehmer': name1,
    'dealer': name2,
  });
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;

  const SearchBar({required this.onSearchChanged});

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

// ignore: must_be_immutable
class ProfileAvatar extends StatelessWidget {
  final String email;
  int a;

  ProfileAvatar({required this.email, required this.a});

  @override
  Widget build(BuildContext context) {
    double radius = a == 0 ? 30.0 : 70.0;
    double size = a == 0 ? 55.0 : 150.0;

    return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.network(
          getProfileImageUrl(email),
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            // Fallback zu lokalem Bild im Fehlerfall
            return Image.asset(
              'assets/ProfilBild.png',
              fit: BoxFit.cover,
              width: size,
              height: size,
            );
          },
        ),
      ),
    );
  }
}

String getProfileImageUrl(String email) {
  return 'https://firebasestorage.googleapis.com/v0/b/skillshare-33883.appspot.com/o/profile_images%2F$email.jpg?alt=media';
}
