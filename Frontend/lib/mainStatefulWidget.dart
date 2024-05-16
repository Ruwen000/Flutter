// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'profil.dart';

class mainStatefulWidget extends StatefulWidget {
  const mainStatefulWidget({super.key});

  @override
  State<mainStatefulWidget> createState() => MainWidget();
}

class MainWidget extends State<mainStatefulWidget> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[home(), const search(), profil()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillShare'),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
