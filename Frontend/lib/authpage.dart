import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/login.dart';
import 'package:mobileapp/mainStatefulWidget.dart';

// ignore: camel_case_types
class authpage extends StatelessWidget {
  const authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const mainStatefulWidget();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
