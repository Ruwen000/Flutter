// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future signIn() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    addDetails(_nameController.text.trim());
    Navigator.pop(context);
  }

  Future addDetails(String name) async {
    await FirebaseFirestore.instance.collection('Nutzer').add({
      'name': name,
    });
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
