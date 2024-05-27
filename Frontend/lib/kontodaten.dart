class kontodaten {
  final String name;
  final List<dynamic> skill;

  kontodaten({required this.name, required this.skill});

  factory kontodaten.fromJson(Map<String, dynamic> json) {
    return kontodaten(
      name: json['name'],
      skill: json['skill'],
    );
  }
}
