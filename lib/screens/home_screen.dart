import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';
import 'camera_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(currentIndex: 0),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Jumat, 7 Februari 2025'),
            Text('Aminiy Ghaisan'),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Absen Masuk")),
                SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Text("Absen Pulang")),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _statCard('Hadir', '5 Hari'),
                _statCard('Izin', '0 Hari'),
                _statCard('Sakit', '0 Hari'),
                _statCard('Terlambat', '1 Hari'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label),
        ],
      ),
    );
  }
}
