// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/kontodaten.dart';
import 'dart:convert';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<StatefulWidget> createState() => searchpage();
}

class searchpage extends State<search> {
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
            child: FutureBuilder<List<kontodaten>>(
              future: fetchDeals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Data Found'));
                } else {
                  List<kontodaten> deals = snapshot.data!;
                  return ListView.builder(
                    itemCount: deals.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('Name: ${deals[index].name}'),
                          subtitle: Text('Talent: ${deals[index].skill}'),
                          onTap: () {
                            setState(() {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                  final Name0 = deals[index].name;
                                  return Scaffold(
                                      appBar: AppBar(
                                        title: Text(Name0),
                                      ),
                                      body: Center(
                                        child: Column(
                                          children: [
                                            const CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  'https://picsum.photos/100'),
                                              radius: 70,
                                            ),
                                            Expanded(
                                                child: ListView.builder(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    itemCount: deals[index]
                                                        .skill
                                                        .length,
                                                    itemBuilder: (context, i) {
                                                      return ListTile(
                                                        title: Text(deals[index]
                                                            .skill[i]),
                                                      );
                                                    }))
                                          ],
                                        ),
                                      ));
                                }),
                              );
                            });
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              sendData();
            },
            child: const Text('Daten senden'),
          ),
        ],
      ),
    );
  }
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

Future<List<kontodaten>> fetchDeals() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:3000/konten'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) => kontodaten.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

sendData() async {
  final response = await http.post(
    Uri.parse(
        'http://10.0.2.2:3000/sendData'), // Beispiel-Endpunkt für das Senden von Daten
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': 'John Doe',
      'email': 'john.doe@example.com',
    }),
  );
  if (response.statusCode == 200) {
    // Erfolgreich gesendet
    print('Daten wurden erfolgreich gesendet');
  } else {
    // Fehler beim Senden
    print('Fehler beim Senden der Daten: ${response.statusCode}');
  }
}
