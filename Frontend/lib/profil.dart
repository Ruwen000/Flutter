import 'package:flutter/material.dart';

Widget profil() {
  return const Center(
    child: Column(
      children: [
        Text("Profil"),
        CircleAvatar(
          backgroundImage: NetworkImage('https://picsum.photos/100'),
          radius: 70,
        ),
        Divider(),
      ],
    ),
  );
}
