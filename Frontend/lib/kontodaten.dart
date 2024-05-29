class kontodaten {
  final String name;
  final List<dynamic> skill;
  final String email;
  final String Ort;

  kontodaten(
      {required this.name,
      required this.skill,
      required this.email,
      required this.Ort});

  factory kontodaten.fromJson(Map<String, dynamic> json) {
    return kontodaten(
      name: json['name'],
      skill: json['skill'],
      email: json['email'],
      Ort: json['Ort'],
    );
  }
}
