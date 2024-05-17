class DealsDaten {
  final int id;
  final String dealMit;

  DealsDaten({required this.id, required this.dealMit});

  factory DealsDaten.fromJson(Map<String, dynamic> json) {
    return DealsDaten(
      id: json['id'],
      dealMit: json['dealMit'],
    );
  }
}
