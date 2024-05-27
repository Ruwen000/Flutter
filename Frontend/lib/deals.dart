import 'dart:convert';
import 'package:mobileapp/DealsKontoInfo.dart';

import 'DealsDaten.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class deals extends StatefulWidget {
  const deals({super.key});

  @override
  State<StatefulWidget> createState() => dealspage();
}

class dealspage extends State<deals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    Future<List<DealsDaten>> fetchDeals() async {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/deals'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => DealsDaten.fromJson(item)).toList();
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

    return Center(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<DealsDaten>>(
              future: fetchDeals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Data Found'));
                } else {
                  List<DealsDaten> deals = snapshot.data!;
                  return ListView.builder(
                    itemCount: deals.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('ID: ${deals[index].id}'),
                          subtitle: Text('Deal Mit: ${deals[index].dealMit}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => dealskontoinfo(
                                    dealMit: deals[index].dealMit),
                              ),
                            );
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
