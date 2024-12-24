import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geospatial_app/providers/region_provider.dart';
import 'package:geospatial_app/screens/region_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<RegionProvider>().fetchRegions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geospatial Data Viewer'),
      ),
      body: Consumer<RegionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          return ListView.builder(
            itemCount: provider.regions.length,
            itemBuilder: (context, index) {
              final region = provider.regions[index];
              return ListTile(
                title: Text(region.name),
                subtitle: Text('Code: ${region.code}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegionDetailsScreen(region: region),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}