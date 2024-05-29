// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class regestrieren extends StatefulWidget {
  const regestrieren({super.key});

  @override
  State<regestrieren> createState() => regestrierenpage();
}

class regestrierenpage extends State<regestrieren> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ortController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    addDetails(_nameController.text.trim());
    sendData(_nameController.text.trim(), _emailController.text.trim(),
        _ortController.text.trim(), _skillController.text.trim());
    Navigator.pop(context);
  }

  Future addDetails(String name) async {
    await FirebaseFirestore.instance.collection('Nutzer').add({
      'name': name,
    });
  }

  sendData(String name, String email, String ort, String skill) async {
    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:3000/sendData'), // Beispiel-Endpunkt für das Senden von Daten
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'Ort': ort,
        'skill': skill,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regestrieren'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Passwort',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Benutzername',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ortController,
                decoration: const InputDecoration(
                  labelText: 'Wohnort',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _skillController,
                decoration: const InputDecoration(
                  labelText: 'Skill',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: signIn,
                child: const Text('Regestrieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
