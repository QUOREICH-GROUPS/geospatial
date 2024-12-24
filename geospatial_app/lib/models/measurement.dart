import 'package:latlong2/latlong.dart';

abstract class Measurement {
  final String id;
  final LatLng location;
  final DateTime sampleDate;
  final Map<String, dynamic> properties;

  Measurement({
    required this.id,
    required this.location,
    required this.sampleDate,
    required this.properties,
  });
}

class ChemicalMeasurement extends Measurement {
  final double? ph;
  final double? conductivity;
  final double? dissolvedOxygen;
  final double? temperature;
  final Map<String, dynamic>? minerals;
  final Map<String, dynamic>? heavyMetals;
  final Map<String, dynamic>? organicCompounds;

  ChemicalMeasurement({
    required super.id,
    required super.location,
    required super.sampleDate,
    required super.properties,
    this.ph,
    this.conductivity,
    this.dissolvedOxygen,
    this.temperature,
    this.minerals,
    this.heavyMetals,
    this.organicCompounds,
  });

  factory ChemicalMeasurement.fromJson(Map<String, dynamic> json) {
    return ChemicalMeasurement(
      id: json['id'],
      location: LatLng(
        json['location']['coordinates'][1],
        json['location']['coordinates'][0],
      ),
      sampleDate: DateTime.parse(json['sample_date']),
      properties: json['properties'] ?? {},
      ph: json['ph']?.toDouble(),
      conductivity: json['conductivity']?.toDouble(),
      dissolvedOxygen: json['dissolved_oxygen']?.toDouble(),
      temperature: json['temperature']?.toDouble(),
      minerals: json['minerals'],
      heavyMetals: json['heavy_metals'],
      organicCompounds: json['organic_compounds'],
    );
  }
}