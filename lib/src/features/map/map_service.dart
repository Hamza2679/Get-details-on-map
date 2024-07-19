import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'map_providers/current_time_provider.dart';
import 'map_providers/location_details_provider.dart';

Future<void> fetchLocationDetails(WidgetRef ref, LatLng location) async {
  final url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${location.latitude}&lon=${location.longitude}&addressdetails=1';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final address = data['address'];
    final city = address['city'] ?? address['town'] ?? address['village'] ?? 'Unknown city';
    final country = address['country'] ?? 'Unknown country';
    ref.read(locationDetailsProvider.notifier).state = 'City: $city\nCountry: $country';
  } else {
    ref.read(locationDetailsProvider.notifier).state = 'Failed to fetch location details.';
  }
}
Future<void> fetchCurrentTime(WidgetRef ref, LatLng location) async {
  final apiKey = '32SIP3RKM6WK';
  final url =
      'https://api.timezonedb.com/v2.1/get-time-zone?key=$apiKey&format=json&by=position&lat=${location.latitude}&lng=${location.longitude}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final localTime = data['formatted'];
    final DateTime dateTime = DateTime.parse(localTime);
    final String formattedTime = DateFormat('h:mm a').format(dateTime);
    ref.read(currentTimeProvider.notifier).state = 'Current Time: $formattedTime';
  } else {
    ref.read(currentTimeProvider.notifier).state = 'Failed to fetch time.';
  }
}
