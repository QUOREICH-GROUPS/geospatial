import 'package:dio/dio.dart';
import 'package:geospatial_app/models/administrative.dart';

class AdministrativeService {
  final Dio _dio;
  final String baseUrl;

  AdministrativeService(this._dio, this.baseUrl);

  Future<List<Region>> getRegions() async {
    try {
      final response = await _dio.get('$baseUrl/administrative/regions');
      return (response.data as List).map((json) => Region.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load regions: $e');
    }
  }

  Future<Region> getRegionDetails(String id) async {
    try {
      final response = await _dio.get('$baseUrl/administrative/regions/$id');
      return Region.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load region details: $e');
    }
  }
}