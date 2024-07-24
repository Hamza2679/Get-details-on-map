import 'package:latlong2/latlong.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LatLng location;
  final String locationDetails;
  final String currentTime;

  LocationLoaded({
    required this.location,
    required this.locationDetails,
    required this.currentTime,
  });
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}
