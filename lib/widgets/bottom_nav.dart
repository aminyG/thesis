import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/camera_screen.dart';
import '/screens/history_screen.dart';
import '/screens/profile_screen.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
            break;
          case 1:
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => CameraScreen()));
            break;
          case 2:
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HistoryScreen()));
            break;
          case 3:
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ProfileScreen()));
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Camera'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
