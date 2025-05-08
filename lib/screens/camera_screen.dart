import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera")),
      body: Center(
          child: ElevatedButton(onPressed: () {}, child: Text("Ambil Foto"))),
      bottomNavigationBar: BottomNav(currentIndex: 1),
    );
  }
}
