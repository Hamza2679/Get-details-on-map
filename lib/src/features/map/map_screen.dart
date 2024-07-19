import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'map_providers/current_time_provider.dart';
import 'map_providers/location_details_provider.dart';
import 'map_providers/tapped_location_provider.dart';
import 'map_service.dart';
import '../../widgets/custom_marker.dart';

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tappedLocation = ref.watch(tappedLocationProvider);
    final currentTime = ref.watch(currentTimeProvider);
    final locationDetails = ref.watch(locationDetailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Map Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(0, 0),
                zoom: 2.0,
                onTap: (tapPosition, point) {
                  ref.read(tappedLocationProvider.notifier).state = point;
                  fetchCurrentTime(ref, point);
                  fetchLocationDetails(ref, point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (tappedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: tappedLocation,
                        builder: (ctx) => CustomMarker(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (tappedLocation != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tapped Location: \nLatitude: ${tappedLocation.latitude}, \nLongitude: ${tappedLocation.longitude}\n$locationDetails\n$currentTime',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
