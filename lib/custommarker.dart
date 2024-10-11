import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Custommarker extends StatefulWidget {
  const Custommarker({super.key});

  @override
  State<Custommarker> createState() => _CustommarkerState();
}

class _CustommarkerState extends State<Custommarker> {
  Completer<GoogleMapController> _controller = Completer();

  Uint8List? markerimage;
  static final CameraPosition _kGoogleplex =
      const CameraPosition(target: LatLng(30.764971, 76.573808), zoom: 14);
  List<String> images = ['images/car.png'];
  List<Marker> _marker = [];
  final List<LatLng> _latlang = <LatLng>[
    LatLng(33.6941, 72.9734), // Ensure values are valid double
  ];

  List<Marker> _list = [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(30.764971, 76.573808),
        infoWindow: InfoWindow(title: 'My Position')),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(30.74753900810396, 76.55695664108188),
        infoWindow: InfoWindow(title: 'My Position'))
  ];
  Future<Uint8List> getBytefromassets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getBytefromassets(images[i], 100);
      Marker(
          markerId: MarkerId('marker_${i}'), // Always pass a String here
          position: LatLng(_latlang[i].latitude,
              _latlang[i].longitude), // This expects double
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
            title: 'Marker ${i}', // InfoWindow title should be String
          ));

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
          'Multiple Marker',
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
