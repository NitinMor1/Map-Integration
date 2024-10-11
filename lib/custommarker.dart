import 'package:flutter/material.dart';

class Custommarker extends StatefulWidget {
  const Custommarker({super.key});

  @override
  State<Custommarker> createState() => _CustommarkerState();
}

class _CustommarkerState extends State<Custommarker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Marker'),
      ),
      body: Container(),
    );
  }
}
