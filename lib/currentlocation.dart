import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Currentlocation extends StatefulWidget {
  const Currentlocation({super.key});

  @override
  State<Currentlocation> createState() => _CurrentlocationState();
}

class _CurrentlocationState extends State<Currentlocation> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGoogleplex =
      const CameraPosition(target: LatLng(30.764971, 76.573808), zoom: 14);
  List<Marker> _marker = [];
  List<Marker> _list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(30.764971, 76.573808),
        infoWindow: InfoWindow(title: 'My Position')),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(30.74753900810396, 76.55695664108188),
        infoWindow: InfoWindow(title: 'My Position'))
  ];

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  Future<Position> getusercurrentlocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permissions are denied, handle accordingly (e.g., show a dialog)
        return Future.error('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Current Location',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: _kGoogleplex,
            mapType: MapType.normal,
            markers: Set<Marker>.of(_marker),
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          try {
            Position position = await getusercurrentlocation();
            print('My location: ${position.latitude}, ${position.longitude}');

            // Update the camera position to the user's location
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14,
                ),
              ),
            );

            setState(() {
              _marker.add(Marker(
                markerId: MarkerId('user_location'),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: InfoWindow(title: 'Current Location'),
              ));
            });
          } catch (e) {
            print("Error fetching location: $e");
          }
        },
        child: Icon(
          Icons.location_disabled_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
