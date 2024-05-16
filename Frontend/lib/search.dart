// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<StatefulWidget> createState() => searchpage();
}

class searchpage extends State<search> {
  final _Names = <String>[];
  final _Fav = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SearchBar(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider();
          }
          if (i ~/ 2 >= _Names.length) {
            _Names.addAll(_Generator());
          }
          return _buildRow(_Names[i ~/ 2]);
        });
  }

  Iterable<String> _Generator() {
    List<String> myNames = [
      'Kevin : IT',
      'Ruwen : Schach',
      'Rudi : Spielen',
      'Michi : essen',
      'Plackner : weinen',
      'Naomi : klettern',
      'Steffen : flicken',
      'Samuel : trainiren',
      'evelyn : alles',
      'Laura : Kochen',
      'Hannah : streiten',
    ];
    return myNames;
  }

  Widget _buildRow(String Name) {
    final marked = _Fav.contains(Name);

    return ListTile(
      title: Text(Name),
      trailing: Icon(
        marked ? Icons.favorite : Icons.favorite_border,
        color: marked ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          marked ? _Fav.remove(Name) : _Fav.add(Name);
        });
      },
      onLongPress: () {
        _pushExampel(Name);
      },
    );
  }

  void _pushExampel(String Name) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        final Name0 = Name;
        return Scaffold(
          appBar: AppBar(
            title: Text(Name0),
          ),
          body: Center(
            child: Image.network('https://picsum.photos/200/300'),
          ),
        );
      }),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText:
            'Suche...', // Text, der erscheint, wenn keine Eingabe erfolgt ist
        border: InputBorder.none,
        icon: Icon(
            Icons.search), // Ein Suchsymbol auf der linken Seite der Suchleiste
      ),
      onChanged: (value) {
        // Hier kannst du Logik einfügen, die bei jeder Änderung im Suchfeld ausgeführt wird
        print('Suchbegriff: $value');
      },
    );
  }
}
