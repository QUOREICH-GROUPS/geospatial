import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geospatial_app/providers/region_provider.dart';
import 'package:geospatial_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegionProvider()),
      ],
      child: MaterialApp(
        title: 'Geospatial Data Viewer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}