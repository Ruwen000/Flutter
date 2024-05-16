import 'package:flutter/material.dart';
import 'anfragen.dart';
import 'deals.dart';

Widget home() {
  return DefaultTabController(
    length: 2, // Anzahl der Tabs
    child: Scaffold(
      appBar: AppBar(
        title: const TabBar(
          tabs: [
            Tab(text: 'Deals'),
            Tab(text: 'Anfragen'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          Center(child: deals()),
          Center(child: anfragen()),
        ],
      ),
    ),
  );
}
