import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobileapp/kontodaten.dart';

class dealskontoinfo extends StatefulWidget {
  final String dealMit;

  // Konstruktor, der den Text als Parameter entgegennimmt
  const dealskontoinfo({super.key, required this.dealMit});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<dealskontoinfo> {
  Future<List<kontodaten>> fetchKontoDaten() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/konten'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => kontodaten.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<kontodaten>>(
                future: fetchKontoDaten(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Data Found'));
                  } else {
                    List<kontodaten> kontodata = snapshot.data!;
                    return ListView.builder(
                      itemCount: kontodata.length,
                      itemBuilder: (context, index) {
                        if (kontodata[index].name == widget.dealMit) {
                          return ListTile(
                            title: Text('Name: ${kontodata[index].name}'),
                            subtitle:
                                Text('Skill: ${kontodata[index].skill[index]}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => dealskontoinfo(
                                      dealMit: kontodata[index].skill[index]),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
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
