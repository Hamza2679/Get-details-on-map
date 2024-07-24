import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationTapped>(_onLocationTapped);
  }

  Future<void> _onLocationTapped(LocationTapped event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      final locationDetails = await fetchLocationDetails(event.point);
      final currentTime = await fetchCurrentTime(event.point);
      emit(LocationLoaded(
        location: event.point,
        locationDetails: locationDetails,
        currentTime: currentTime,
      ));
    } catch (e) {
      emit(LocationError('Failed to load location details and time: ${e.toString()}'));
    }
  }

  Future<String> fetchLocationDetails(LatLng location) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${location.latitude}&lon=${location.longitude}&addressdetails=1';
    final response = await http.get(Uri.parse(url));
    print('fetchLocationDetails response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final address = data['address'];
      final city = address['city'] ?? address['town'] ?? address['village'] ?? 'Unknown city';
      final country = address['country'] ?? 'Unknown country';
      return 'City: $city\nCountry: $country';
    } else {
      throw Exception('Failed to fetch location details: ${response.reasonPhrase}');
    }
  }

  Future<String> fetchCurrentTime(LatLng location) async {
    final apiKey = '32SIP3RKM6WK'; // Ensure this is securely managed
    final url =
        'https://api.timezonedb.com/v2.1/get-time-zone?key=$apiKey&format=json&by=position&lat=${location.latitude}&lng=${location.longitude}';
    final response = await http.get(Uri.parse(url));
    print('fetchCurrentTime response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final localTime = data['formatted'];
      final DateTime dateTime = DateTime.parse(localTime);
      return DateFormat('h:mm a').format(dateTime);
    } else {
      throw Exception('Failed to fetch time: ${response.reasonPhrase}');
    }
  }
}
