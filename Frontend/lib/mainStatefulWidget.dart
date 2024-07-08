// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'profil.dart';

class mainStatefulWidget extends StatefulWidget {
  const mainStatefulWidget({Key? key});

  @override
  State<mainStatefulWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<mainStatefulWidget> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[home(), const search(), const Profil()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
          padding: const EdgeInsets.only(top: 20.0),
          color: Colors.blue[900],
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Skill',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16), // Abstand zwischen Skill und Logo
                Image.asset(
                  'assets/logo.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 16), // Abstand zwischen Logo und Share
                const Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex], // Direkt das gewählte page-Widget anzeigen
      backgroundColor: Colors.black, // Hintergrundfarbe der App in Schwarz
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor:
            Colors.white, // Farbe für nicht ausgewählte Symbole
        backgroundColor: Colors
            .black, // Hintergrundfarbe der Bottom Navigation Bar in Schwarz
        onTap: _onItemTapped,
      ),
    );
  }
}
