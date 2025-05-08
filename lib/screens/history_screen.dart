import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '/widgets/bottom_nav.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: now,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Daftar Kehadiran",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          AttendanceItem(time: '08:44', label: 'Masuk', color: Colors.green),
          AttendanceItem(time: '14:55', label: 'Pulang', color: Colors.red),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}

class AttendanceItem extends StatelessWidget {
  final String time;
  final String label;
  final Color color;

  const AttendanceItem({
    Key? key,
    required this.time,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.fingerprint, color: color, size: 32),
      title: Text(time),
      subtitle: Text(label),
    );
    // return Scaffold(
    //   appBar: AppBar(title: Text("Riwayat")),
    //   body: Center(child: Text('Riwayat Kehadiran')),
    //   bottomNavigationBar: BottomNav(currentIndex: 2),
    // );
  }
}
