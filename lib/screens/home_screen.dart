import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jum’at, 7 Februari 2025',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Aminy Ghaisan',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        minimumSize: Size(140, 50), // Optional: Better sizing
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Absen Masuk"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        minimumSize: Size(140, 50), // Optional: Better sizing
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Absen Pulang"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Belum Absen',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Absensi Bulan Februari 2025',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: _statCardWithIcon(
                            'Hadir', '4 Hari', Icons.check_circle)),
                    SizedBox(width: 10),
                    Expanded(
                        child: _statCardWithIcon(
                            'Izin', '0 Hari', Icons.remove_circle)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: _statCardWithIcon(
                            'Sakit', '0 Hari', Icons.healing)),
                    SizedBox(width: 10),
                    Expanded(
                        child: _statCardWithIcon(
                            'Terlambat', '1 Hari', Icons.access_time)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCardWithIcon(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          SizedBox(height: 5),
          Text(value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label),
        ],
      ),
    );
  }
}
