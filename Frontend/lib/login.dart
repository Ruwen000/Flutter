// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/regestrieren.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => loginpage();
}

class loginpage extends State<login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        print('No User found');
        wrongEmail();
      } else {
        print('Wrong Passwort');
        wrongPasswort();
      }
    }
  }

  void wrongEmail() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Falsche Email'),
          );
        });
  }

  void wrongPasswort() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Falsches Passwort'),
          );
        });
  }

  void _register(BuildContext context) {
    // Hier kannst du die neue Seite öffnen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const regestrieren()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte E-Mail eingeben';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Bitte eine gültige E-Mail eingeben';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Passwort',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Passwort eingeben';
                  }
                  if (value.length < 6) {
                    return 'Das Passwort muss mindestens 6 Zeichen lang sein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Anmelden'),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () => _register(context),
                child: const Text(
                  'Registrieren',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
