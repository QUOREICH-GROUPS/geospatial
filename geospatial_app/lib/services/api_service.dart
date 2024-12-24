import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://your-api-url.onrender.com/api';

  Future<List<dynamic>> getRegions() async {
    try {
      final response = await _dio.get('$baseUrl/administrative/regions');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load regions: $e');
    }
  }

  Future<Map<String, dynamic>> getRegionDetails(String id) async {
    try {
      final response = await _dio.get('$baseUrl/administrative/regions/$id');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load region details: $e');
    }
  }

  Future<List<dynamic>> getMeasurements(String type, {
    required double minLat,
    required double minLng,
    required double maxLat,
    required double maxLng,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/measurements/$type',
        queryParameters: {
          'minLat': minLat,
          'minLng': minLng,
          'maxLat': maxLat,
          'maxLng': maxLng,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load $type measurements: $e');
    }
  }
}