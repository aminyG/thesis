import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  // Function to handle the password reset request
  Future<void> resetPassword() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final response = await http.post(
      Uri.parse('http://presence.guestallow.com/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': emailController.text}),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Success'),
          content: Text(data['message']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to login screen
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      final data = jsonDecode(response.body);
      setState(() {
        errorMessage =
            data['message'] ?? 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman login
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                'Password Recovery',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 20), // Spasi antara judul dan teks
              Text(
                'We\'ll send you a new password to your mailbox',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
              SizedBox(height: 40),
              // Email input dengan style
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email, color: Color(0xFF3B6790)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF3B6790)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF3B6790)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Error Message
              if (errorMessage != null) ...[
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
              SizedBox(height: 20),
              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : resetPassword,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF3B6790),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Done',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              SizedBox(height: 10),
              // Option to go back to login page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remembered your password? ',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to login
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Color(0xFF3B6790)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
