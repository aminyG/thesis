// /screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.grey),
            const SizedBox(height: 10),
            const Text('Aminiy Ghaisan', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('294782'), // NIP
            const SizedBox(height: 30),
            MenuButton(text: 'Data Profil', onTap: () {
              Navigator.pushNamed(context, '/edit_profile');
            }),
            MenuButton(text: 'Ubah Kata Sandi', onTap: () {
              Navigator.pushNamed(context, '/change_password');
            }),
            MenuButton(text: 'Perekam Wajah', onTap: () {
              Navigator.pushNamed(context, '/face_recorder');
            }),
            // MenuButton(text: 'Keluar', onTap: () {
            //   // TODO: implement logout logic
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("Keluar dari aplikasi")),
            //   );
            MenuButton(text: 'Keluar', onTap: () {
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            }),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const MenuButton({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
