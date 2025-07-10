// import 'dart:convert';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/services/face_api_service.dart';
// import 'package:flutter_application_1/widgets/bottom_nav.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _controller;
//   Future<void>? _initializeControllerFuture;
//   bool isLoading = false;
//   String? errorMessage;
//   String? userIdentifier;

//   @override
//   void initState() {
//     super.initState();
//     _setupCamera();
//     _getAuthenticatedUser();
//   }

//   Future<void> _setupCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front,
//     );

//     _controller = CameraController(frontCamera, ResolutionPreset.medium);
//     _initializeControllerFuture = _controller!.initialize();
//     if (mounted) setState(() {});
//   }

//   Future<void> _getAuthenticatedUser() async {
//     try {
//       final token = await _getAuthToken();
//       if (token == null) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('User is not logged in.')));
//         return;
//       }

//       final response = await http.get(
//         Uri.parse('https://presence.guestallow.com/api/users/me'),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           userIdentifier = data['user']['id'].toString();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to retrieve user details')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
//     }
//   }

//   Future<String?> _getAuthToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> _verifyFace() async {
//     if (userIdentifier == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User identifier not available')),
//       );
//       return;
//     }

//     final token = await _getAuthToken();
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Token not available. Please log in again.')),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       await _initializeControllerFuture;
//       final image = await _controller!.takePicture();
//       final File file = File(image.path);

//       final apiService = FaceApiService();
//       final result = await apiService.verifyFace(
//         imageFile: file,
//         identifier: userIdentifier!,
//         token: token,
//       );

//       if (result['status_code'] == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('✅ ${result['message']}')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('❌ ${result['message']}')),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Face Verification")),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _controller == null
//                   ? Center(child: CircularProgressIndicator())
//                   : FutureBuilder(
//                       future: _initializeControllerFuture,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           return ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: AspectRatio(
//                               aspectRatio: 3 / 4.5,
//                               child: CameraPreview(_controller!),
//                             ),
//                           );
//                         } else {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                       },
//                     ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: isLoading ? null : _verifyFace,
//                 child: isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : Text("Verify Face"),
//               ),
//               if (errorMessage != null)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     errorMessage!,
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNav(currentIndex: 1),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/face_api_service.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _setupCamera();
    _getAuthenticatedUser();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _getAuthenticatedUser() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User is not logged in.')));
        return;
      }

      final response = await HttpClient()
          .getUrl(Uri.parse('https://presence.guestallow.com/api/users/me'))
          .then((req) {
        req.headers.add('Accept', 'application/json');
        req.headers.add('Authorization', 'Bearer $token');
        return req.close();
      });

      final responseBody = await response.transform(utf8.decoder).join();
      print('GET /users/me => $responseBody');

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        setState(() {
          userIdentifier = data['user']['id'].toString();
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

  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('Retrieved Token: $token');
    return token;
  }

  Future<void> _verifyFace() async {
    if (userIdentifier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User identifier not available')),
      );
      return;
    }

    final token = await _getAuthToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token not available. Please log in again.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      final File file = File(image.path);

      // Log detail request
      print('---- VERIFY REQUEST ----');
      print('Identifier: $userIdentifier');
      print('Token: $token');
      print('Image path: ${file.path}');
      print('Image size: ${await file.length()} bytes');

      final apiService = FaceApiService();
      final result = await apiService.verifyFace(
        imageFile: file,
        identifier: userIdentifier!,
        token: token,
      );

      print('---- VERIFY RESPONSE ----');
      print(result);

      if (result['status_code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ ${result['message']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ ${result['message']}')),
        );
      }
    } catch (e, stack) {
      print('EXCEPTION OCCURRED: $e');
      print(stack);
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _controller == null
                  ? Center(child: CircularProgressIndicator())
                  : FutureBuilder(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: AspectRatio(
                              aspectRatio: 3 / 4.5,
                              child: CameraPreview(_controller!),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _verifyFace,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Verify Face"),
              ),
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
