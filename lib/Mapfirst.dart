import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapfirst extends StatefulWidget {
  @override
  State<Mapfirst> createState() => MapfirstState();
}

class MapfirstState extends State<Mapfirst> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Google Map',
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
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(30.764971, 76.573808), zoom: 14)));
          setState(() {});
        },
        child: Icon(
          Icons.location_disabled_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
