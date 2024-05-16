// ignore_for_file: camel_case_types

class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(id: json['id'], name: json['name']);
  }
}
