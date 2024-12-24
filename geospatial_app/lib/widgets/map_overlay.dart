import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geospatial_app/models/measurement.dart';

class MapOverlay extends StatelessWidget {
  final List<List<LatLng>> polygons;
  final List<ChemicalMeasurement>? measurements;
  final void Function(LatLng) onTapMeasurement;

  const MapOverlay({
    super.key,
    required this.polygons,
    this.measurements,
    required this.onTapMeasurement,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...polygons.map(
          (polygon) => PolygonLayer(
            polygons: [
              Polygon(
                points: polygon,
                color: Colors.blue.withOpacity(0.2),
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
              ),
            ],
          ),
        ),
        if (measurements != null)
          MarkerLayer(
            markers: measurements!.map((m) => Marker(
              point: m.location,
              width: 30,
              height: 30,
              builder: (context) => GestureDetector(
                onTap: () => onTapMeasurement(m.location),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
              ),
            )).toList(),
          ),
      ],
    );
  }
}