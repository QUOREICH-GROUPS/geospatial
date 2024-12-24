class Region {
  final String id;
  final String name;
  final String code;
  final Map<String, dynamic> properties;

  Region({
    required this.id,
    required this.name,
    required this.code,
    required this.properties,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      properties: json['properties'] ?? {},
    );
  }
}