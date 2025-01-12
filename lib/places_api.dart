import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class PlacesApi extends StatefulWidget {
  const PlacesApi({super.key});

  @override
  State<PlacesApi> createState() => _PlacesApiState();
}

class _PlacesApiState extends State<PlacesApi> {
  TextEditingController _controller = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesList = [];
  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      onchange();
    });
  }

  void onchange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyDaelXEVLRXBbPoCW-xIKanCc98WsXN_K4";

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print('data');
    print(data);
    if (response.statusCode == 200) {
      print(response.body.toString());
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Google Search Api'),
        ),
        body: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Search places with name'),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: _placesList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              _placesList[index]['description']);
                          print(locations.last.latitude);
                          print(locations.last.longitude);
                        },
                        title: Text(_placesList[index]['description']),
                      );
                    }))
          ],
        ));
  }
}
