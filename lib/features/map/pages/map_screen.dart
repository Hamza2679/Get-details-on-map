import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/pages/login_page.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';
import '../widgets/custom_marker.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Get Time',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white,),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(0, 0),
                zoom: 2.0,
                onTap: (tapPosition, point) {
                  print('Map tapped at point: $point');
                  context.read<LocationBloc>().add(LocationTapped(point));
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, state) {
                    if (state is LocationLoaded) {
                      print('MarkerLayer rendering at location: ${state.location}');
                      return MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: state.location,
                            builder: (ctx) => CustomMarker(),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              if (state is LocationInitial) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Tap on the map to get the current time.',
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is LocationLoading) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              } else if (state is LocationLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Tapped Location: \nLatitude: ${state.location.latitude}, \nLongitude: ${state.location.longitude}\n${state.locationDetails}\n${state.currentTime}',
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is LocationError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
