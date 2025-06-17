import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool isLoading = false;
  String? errorMessage;
  String? userIdentifier;

  // Initialize the camera and fetch user info
  @override
  void initState() {
    super.initState();
    _setupCamera();
    _getAuthenticatedUser(); // Fetch authenticated user
  }

  // Set up the camera controller and initialize the camera
  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium, // Adjust resolution for wider field of view
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});

    // Apply default zoom level (optional)
    await _controller!.setZoomLevel(-5.0);
  }

  // Fetch authenticated user and retrieve the user identifier
  Future<void> _getAuthenticatedUser() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User is not logged in.')));
        return;
      }

      final response = await http.get(
        Uri.parse('https://presence.guestallow.com/api/users/me'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Pass the token in headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userIdentifier =
              data['user']['id']; // Assuming user object contains 'id'
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to retrieve user details')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  // Retrieve token from SharedPreferences
  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token;
  }

  // Capture and verify the face
  Future<void> _verifyFace() async {
    if (userIdentifier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User identifier not available')),
      );
      return;
    }

    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      final File file = File(image.path);

      final uri =
          Uri.parse('http://presence.guestallow.com/api/users/verify-face');
      final request = http.MultipartRequest('POST', uri);

      final photo = await http.MultipartFile.fromPath(
        'photo',
        file.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(photo);

      // Add the identifier to the request
      request.fields['identifier'] = userIdentifier!;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Face verification successful: ${responseData.body}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Face verification failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Verification")),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 20), // Add padding for spacing
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Camera Preview with Aspect Ratio to avoid distortion
              _controller == null
                  ? Center(child: CircularProgressIndicator())
                  : FutureBuilder(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                            child: AspectRatio(
                              aspectRatio: 3 /
                                  4.5, // Adjusting aspect ratio for better fit
                              child: CameraPreview(_controller!),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
              SizedBox(height: 20),
              // Face Verification Button
              ElevatedButton(
                onPressed: isLoading ? null : _verifyFace,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Verify Face"),
              ),
              // Error Message Display
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 1),
    );
  }
}
