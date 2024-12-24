import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geospatial_app/models/administrative.dart';
import 'package:geospatial_app/models/measurement.dart';
import 'package:geospatial_app/services/measurement_service.dart';
import 'package:geospatial_app/widgets/map_overlay.dart';

class RegionDetailsScreen extends StatefulWidget {
  final Region region;

  const RegionDetailsScreen({super.key, required this.region});

  @override
  State<RegionDetailsScreen> createState() => _RegionDetailsScreenState();
}

class _RegionDetailsScreenState extends State<RegionDetailsScreen> {
  final MeasurementService _measurementService = MeasurementService(
    Dio(),
    'https://your-api-url.onrender.com/api',
  );
  List<ChemicalMeasurement>? _measurements;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMeasurements();
  }

  Future<void> _loadMeasurements() async {
    setState(() => _isLoading = true);
    try {
      final bounds = LatLngBounds.fromPoints(
        widget.region.geometry.expand((x) => x).toList(),
      );
      final measurements = await _measurementService.getChemicalData(bounds);
      setState(() => _measurements = measurements);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading measurements: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMeasurementDetails(LatLng location) {
    final measurement = _measurements?.firstWhere(
      (m) => m.location == location,
    );
    if (measurement == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Chemical Measurement',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (measurement.ph != null)
              Text('pH: ${measurement.ph}'),
            if (measurement.temperature != null)
              Text('Temperature: ${measurement.temperature}°C'),
            if (measurement.conductivity != null)
              Text('Conductivity: ${measurement.conductivity} µS/cm'),
            if (measurement.dissolvedOxygen != null)
              Text('Dissolved Oxygen: ${measurement.dissolvedOxygen} mg/L'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final center = widget.region.geometry.first.first;
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.region.name)),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: center,
                zoom: 8,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.geospatial_app',
                ),
                MapOverlay(
                  polygons: widget.region.geometry,
                  measurements: _measurements,
                  onTapMeasurement: _showMeasurementDetails,
                ),
              ],
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(),
        ],
      ),
    );
  }
}