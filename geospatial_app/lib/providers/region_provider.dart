import 'package:flutter/foundation.dart';
import 'package:geospatial_app/models/region.dart';
import 'package:geospatial_app/services/api_service.dart';

class RegionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Region> _regions = [];
  bool _isLoading = false;
  String? _error;

  List<Region> get regions => _regions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRegions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getRegions();
      _regions = data.map((json) => Region.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}