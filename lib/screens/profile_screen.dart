import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 40),
            SizedBox(height: 10),
            Text('Aminiy Ghaisan'),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("Ubah Data Profil")),
          ],
        ),
      ),
    );
  }
}
