import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Polygons extends StatefulWidget {
  const Polygons({super.key});

  @override
  State<Polygons> createState() => _PolygonsExampleState();
}

class _PolygonsExampleState extends State<Polygons> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(30.764971, 76.573808),
    zoom: 14,
  );

  List<Marker> _markers = [];
  Set<Polygon> _polygons = HashSet<Polygon>();

  List<LatLng> points = [
    LatLng(30.764971, 76.573808),
    LatLng(30.74753900810396, 76.55695664108188),
    LatLng(30.750000, 76.570000), // Unique third point
  ];

  @override
  void initState() {
    super.initState();
    _polygons.add(Polygon(
      polygonId: PolygonId('1'),
      points: points,
      fillColor: Colors.red.withOpacity(0.5), // Add transparency
      strokeColor: Colors.red,
      strokeWidth: 4,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Map Polygons',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          zoomControlsEnabled: false,
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          polygons: _polygons,
          markers: Set<Marker>.of(_markers),
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: LatLng(30.764971, 76.573808),
              zoom: 14,
            ),
          ));
        },
        child: const Icon(
          Icons.location_disabled_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
