import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class LatLang extends StatefulWidget {
  const LatLang({super.key});

  @override
  State<LatLang> createState() => _LatLangState();
}

class _LatLangState extends State<LatLang> {
  String _address =
      "Tap the button to convert coordinates"; // To display the address

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              await _convertCoordinates();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.green),
                child: const Center(child: Text('Convert')),
              ),
            ),
          ),
          const SizedBox(height: 20), // Add some spacing
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _address,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _convertCoordinates() async {
    try {
      // Use your coordinates here
      List<Placemark> placemarks =
          await placemarkFromCoordinates(30.764971, 76.573808);
      Placemark place = placemarks[0];
      setState(() {
        _address =
            '${place.street}, ${place.locality}, ${place.country}'; // Format the address
      });
      print('Address: $_address');
    } catch (e) {
      print('Error: $e');
      setState(() {
        _address = 'Failed to convert coordinates';
      });
    }
  }
}
