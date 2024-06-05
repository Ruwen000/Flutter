import 'package:flutter/material.dart';
import 'anfragen.dart';
import 'deals.dart';

Widget home() {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        toolbarHeight: 1.0, // Höhe der AppBar verringern
        bottom: const TabBar(
          indicatorColor: Colors.white,
          indicatorWeight: 3.0,
          tabs: [
            Tab(
              icon: Icon(Icons.local_offer),
              text: 'Deals',
            ),
            Tab(
              icon: Icon(Icons.request_page),
              text: 'Anfragen',
            ),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          deals(),
          anfragen(),
        ],
      ),
    ),
  );
}
