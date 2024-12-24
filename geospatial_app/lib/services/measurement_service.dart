import 'package:dio/dio.dart';
import 'package:geospatial_app/models/measurement.dart';
import 'package:latlong2/latlong.dart';

class MeasurementService {
  final Dio _dio;
  final String baseUrl;

  MeasurementService(this._dio, this.baseUrl);

  Future<List<ChemicalMeasurement>> getChemicalData(LatLngBounds bounds) async {
    try {
      final response = await _dio.get(
        '$baseUrl/measurements/chemical',
        queryParameters: {
          'minLat': bounds.southWest.latitude,
          'minLng': bounds.southWest.longitude,
          'maxLat': bounds.northEast.latitude,
          'maxLng': bounds.northEast.longitude,
        },
      );
      
      return (response.data as List)
        .map((json) => ChemicalMeasurement.fromJson(json))
        .toList();
    } catch (e) {
      throw Exception('Failed to load chemical measurements: $e');
    }
  }
}