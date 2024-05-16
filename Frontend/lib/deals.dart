import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Widget deals() {
  fetchitems() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/data'));
    if (response.statusCode == 200) {
      return response.body;
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
        FutureBuilder(
          future: fetchitems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('Data from server: ${snapshot.data}');
            }
          },
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
