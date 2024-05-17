class searchDaten {
  final String name;
  final List<dynamic> skill;

  searchDaten({required this.name, required this.skill});

  factory searchDaten.fromJson(Map<String, dynamic> json) {
    return searchDaten(
      name: json['name'],
      skill: json['skill'],
    );
  }
}
