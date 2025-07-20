import 'package:flutter/material.dart';
import 'package:presence_app/screens/forgot_password_screen.dart';
import 'home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;
  bool rememberMe = false;
  bool obscurePassword = true;

  Future<void> loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('email') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> saveRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', rememberMe);
    prefs.setString('email', emailController.text);
    prefs.setString('password', passwordController.text);
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "Email dan password tidak boleh kosong.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://presence.guestallow.com/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          // 'password': '123456', // Default password
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token']; // Get the token from response
        final user = data['user'];

        print('✅ Login berhasil. TOKEN: $token');

        // Save the token and user info in shared preferences for future requests
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', token);
        prefs.setString('userName', user['name']);

        // Remember user credentials if selected
        if (rememberMe) {
          prefs.setBool('rememberMe', true);
          prefs.setString('email', emailController.text);
        } else {
          prefs.remove('rememberMe');
          prefs.remove('email');
          prefs.remove('password');
        }

        // Navigate to home screen after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        final error = jsonDecode(response.body);
        setState(() {
          errorMessage = error['message'] ?? "Login gagal. Coba lagi.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Terjadi kesalahan jaringan.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              SizedBox(height: 120),
              Text('Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF3B6790)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF3B6790),
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF3B6790)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF3B6790)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: rememberMe,
                  //       onChanged: (bool? value) {
                  //         setState(() {
                  //           rememberMe = value ?? false;
                  //         });
                  //       },
                  //       activeColor: Color(0xFF3B6790),
                  //     ),
                  //     Text('Remember me',
                  //         style: TextStyle(color: Colors.black)),
                  //   ],
                  // ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text('Forgot Password?',
                        style: TextStyle(color: Color(0xFF3B6790))),
                  ),
                ],
              ),
              if (errorMessage != null) ...[
                Text(errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 14)),
              ],
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF3B6790),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Sign In', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
