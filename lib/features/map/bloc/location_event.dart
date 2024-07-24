import 'package:latlong2/latlong.dart';

abstract class LocationEvent {}

class LocationTapped extends LocationEvent {
  final LatLng point;

  LocationTapped(this.point);
}
