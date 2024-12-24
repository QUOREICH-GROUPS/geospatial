import 'package:latlong2/latlong.dart';

class AdministrativeArea {
  final String id;
  final String name;
  final String code;
  final List<List<LatLng>> geometry;
  final Map<String, dynamic> properties;

  AdministrativeArea({
    required this.id,
    required this.name,
    required this.code,
    required this.geometry,
    required this.properties,
  });

  factory AdministrativeArea.fromJson(Map<String, dynamic> json) {
    final coordinates = json['geometry']['coordinates'][0][0] as List;
    final geometry = coordinates.map((coord) {
      return LatLng(coord[1].toDouble(), coord[0].toDouble());
    }).toList();

    return AdministrativeArea(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      geometry: [geometry],
      properties: json['properties'] ?? {},
    );
  }
}

class Region extends AdministrativeArea {
  final List<Province>? provinces;

  Region({
    required super.id,
    required super.name,
    required super.code,
    required super.geometry,
    required super.properties,
    this.provinces,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    final area = AdministrativeArea.fromJson(json);
    final provinces = (json['provinces'] as List?)?.map((p) => Province.fromJson(p)).toList();

    return Region(
      id: area.id,
      name: area.name,
      code: area.code,
      geometry: area.geometry,
      properties: area.properties,
      provinces: provinces,
    );
  }
}