import 'package:flutter/material.dart';
import 'anfragen.dart';
import 'deals.dart';

Widget home() {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        toolbarHeight: 1.0, // Höhe der AppBar verringern
        bottom: TabBar(
          indicatorColor: Colors.white,
          indicatorWeight: 3.0,
          labelColor: Colors.blue[300], // Farbe für ausgewählte Tabs
          unselectedLabelColor:
              Colors.white, // Farbe für nicht ausgewählte Tabs
          tabs: [
            Tab(
              icon: Icon(Icons.local_offer, color: Colors.blue[300]),
              child: const Text(
                'Deals',
              ),
            ),
            Tab(
              icon: Icon(Icons.request_page, color: Colors.blue[300]),
              child: const Text(
                'Anfragen',
              ),
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
