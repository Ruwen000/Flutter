import 'dart:convert';

import 'package:flutter/material.dart';
import 'Item.dart';
import 'package:http/http.dart' as http;

Widget deals() {
  Future<List<Item>> fetchitems() async {
    final response = await http.get(Uri.parse('http://localhost:3000/app'));

    if (response.statusCode == 200) {
      final itemlist = jsonDecode(response.body);
      final items = itemlist.map((item) {
        return item.fromJson(item);
      }).toList();
      return items;
    } else {
      throw Exception("Failed to fetch items");
    }
  }

  return Center(
    child: Column(
      children: [
        FutureBuilder(
            future: fetchitems(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return ListTile(
                        title: Text(item.name),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
      ],
    ),
  );
}
