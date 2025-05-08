import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;

  bool _isPasswordValid = true;

  bool _isValidPassword(String pass) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(pass);
  }

  void _savePassword() {
    final old = oldPassCtrl.text.trim();
    final newP = newPassCtrl.text.trim();
    final confirm = confirmPassCtrl.text.trim();

    if (old.isEmpty || newP.isEmpty || confirm.isEmpty) {
      _showError('Semua kolom wajib diisi');
      return;
    }

    if (!_isValidPassword(newP)) {
      _showError('Password minimal 8 karakter, harus ada huruf besar, kecil, dan angka');
      return;
    }

    if (newP != confirm) {
      _showError('Konfirmasi sandi tidak cocok');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kata sandi berhasil diubah')),
    );
    Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    newPassCtrl.addListener(() {
      final valid = _isValidPassword(newPassCtrl.text.trim());
      if (valid != _isPasswordValid) {
        setState(() => _isPasswordValid = valid);
      }
    });
  }

  @override
  void dispose() {
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Kata Sandi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPasswordField(
              controller: oldPassCtrl,
              label: 'Kata Sandi Lama',
              obscure: !_showOld,
              toggle: () => setState(() => _showOld = !_showOld),
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: newPassCtrl,
              label: 'Kata Sandi Baru',
              obscure: !_showNew,
              toggle: () => setState(() => _showNew = !_showNew),
            ),
            if (!_isPasswordValid)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '❗ Minimal 8 karakter, huruf besar, kecil, dan angka',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: confirmPassCtrl,
              label: 'Kata Sandi Baru (Konfirmasi)',
              obscure: !_showConfirm,
              toggle: () => setState(() => _showConfirm = !_showConfirm),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePassword,
                child: const Text('SIMPAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
      ),
    );
  }
}
