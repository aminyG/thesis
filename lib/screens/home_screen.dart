import 'package:flutter/material.dart';
import 'package:presence_app/screens/camera_screen.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '/widgets/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'face_recorder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String currentDate;
  late String currentTime;
  late Timer _timer;
  String userName = "John Doe";
  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });

    _loadUserName();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "John Doe";
    });
  }

  void navigateToCameraScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );
  }

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
                _buildDateAndTime(),
                SizedBox(height: 20),
                Text(
                  userName,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 20),
                _buildAbsenButtons(),
                SizedBox(height: 10),
                _buildAbsenceStatus(),
                SizedBox(height: 30),
                _buildAbsenceStats(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentDate,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        SizedBox(height: 8),
        Text(
          currentTime,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3B6790)),
        ),
      ],
    );
  }

  Widget _buildAbsenButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: navigateToCameraScreen,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3B6790),
            foregroundColor: Colors.white,
            minimumSize: Size(140, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
          ),
          child: Text("Absen Masuk"),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: navigateToCameraScreen,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3B6790),
            foregroundColor: Colors.white,
            minimumSize: Size(140, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
          ),
          child: Text("Absen Pulang"),
        ),
      ],
    );
  }

  Widget _buildAbsenceStatus() {
    return Center(
      child: Text(
        'Belum Absen',
        style: TextStyle(
            fontSize: 14, color: Colors.red, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildAbsenceStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Absensi Bulan Februari 2025',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _statCardWithIcon(
                  'Hadir', '4 Hari', Icons.check_circle, Color(0xFF3B6790)),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _statCardWithIcon(
                  'Izin', '0 Hari', Icons.remove_circle, Colors.orange),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _statCardWithIcon(
                  'Sakit', '0 Hari', Icons.healing, Colors.green),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _statCardWithIcon(
                  'Terlambat', '1 Hari', Icons.access_time, Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCardWithIcon(
      String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: iconColor),
          SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text(label,
              style: TextStyle(
                  fontSize: 14, color: Colors.black.withOpacity(0.6))),
        ],
      ),
    );
  }
}
