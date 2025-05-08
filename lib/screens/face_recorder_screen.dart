// /screens/face_recorder_screen.dart

import 'package:flutter/material.dart';

class FaceRecorderScreen extends StatelessWidget {
  const FaceRecorderScreen({Key? key}) : super(key: key);

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data Wajah"),
        content: const Text("Yakin ingin menghapus wajah yang sudah direkam?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Wajah dihapus")),
              );
              // TODO: implement delete logic
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  void _recordFace(BuildContext context) {
    // TODO: implement face recording logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rekam wajah dimulai...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perekam Wajah')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.face, size: 100, color: Colors.grey),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _recordFace(context),
                icon: const Icon(Icons.videocam),
                label: const Text("Rekam Wajah Baru"),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDeleteConfirmation(context),
                icon: const Icon(Icons.delete),
                label: const Text("Hapus Wajah"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
