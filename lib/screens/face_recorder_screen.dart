// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart'; // Import ImagePicker
// import 'package:shared_preferences/shared_preferences.dart';

// class FaceRecorderScreen extends StatefulWidget {
//   @override
//   _FaceRecorderScreenState createState() => _FaceRecorderScreenState();
// }

// class _FaceRecorderScreenState extends State<FaceRecorderScreen> {
//   File? _imageFile; // Variable to store picked image
//   final picker = ImagePicker(); // Initialize ImagePicker

//   // Get the authentication token from SharedPreferences
//   Future<String?> _getAuthToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     print("Token retrieved: $token");
//     return token;
//   }

//   // Show dialog to let the user choose between camera or gallery
//   void _showImagePickerOptions() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Pick an Image"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 title: Text("Take a Photo"),
//                 onTap: () {
//                   _pickImage(ImageSource.camera); // Call method to pick image from camera
//                   Navigator.pop(context); // Close dialog
//                 },
//               ),
//               ListTile(
//                 title: Text("Choose from Gallery"),
//                 onTap: () {
//                   _pickImage(ImageSource.gallery); // Call method to pick image from gallery
//                   Navigator.pop(context); // Close dialog
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Pick image either from camera or gallery
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await picker.pickImage(source: source); // Get the image
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = File(pickedFile.path); // Store picked image
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('No image selected.')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error picking image: ${e.toString()}')));
//     }
//   }

//   // Register face using the selected image
//   Future<void> _registerFace() async {
//     final token = await _getAuthToken();
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Token is missing, please log in again.')));
//       return;
//     }

//     if (_imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No image selected for registration.')));
//       return;
//     }

//     // Proceed to register the face with the selected image
//     final uri = Uri.parse('https://presence.guestallow.com/api/users/face');
//     final request = http.MultipartRequest('POST', uri)
//       ..headers['Accept'] = 'application/json'
//       ..headers['Content-Type'] = 'multipart/form-data';

//     final photo = await http.MultipartFile.fromPath(
//       'photo',
//       _imageFile!.path,
//       contentType: MediaType('image', 'jpeg'),
//     );

//     request.files.add(photo);

//     // Assuming userIdentifier is available, add it to the request
//     request.fields['identifier'] = 'userIdentifier'; // Replace with actual identifier

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final responseData = await http.Response.fromStream(response);
//       print('Face registration response: ${responseData.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Face registration successful')));
//     } else {
//       final responseData = await http.Response.fromStream(response);
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to register face')));
//       print('Error: ${responseData.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Face Recorder")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _showImagePickerOptions, // Show the dialog to pick image
//               child: Text("Rekam Wajah Baru"),
//             ),
//             SizedBox(height: 20),
//             _imageFile == null
//                 ? Text("No image selected.")
//                 : Image.file(_imageFile!), // Display selected image
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _registerFace, // Register face with selected image
//               child: Text("Register Face"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceRecorderScreen extends StatefulWidget {
  @override
  _FaceRecorderScreenState createState() => _FaceRecorderScreenState();
}

class _FaceRecorderScreenState extends State<FaceRecorderScreen> {
  File? _imageFile;
  final picker = ImagePicker();

  // ✅ Fungsi untuk compress gambar
  Future<File> compressImage(File file) async {
    final rawBytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(rawBytes);

    if (image == null) throw Exception('Failed to decode image');

    // Resize ke max width 800
    final resized = img.copyResize(image, width: 800);

    // Encode JPEG quality 85
    final compressedBytes = img.encodeJpg(resized, quality: 85);

    // Simpan file hasil kompres di cache/temp
    final tempDir = Directory.systemTemp;
    final compressedFile = File('${tempDir.path}/compressed_face.jpg');
    await compressedFile.writeAsBytes(Uint8List.fromList(compressedBytes));
    return compressedFile;
  }

  // ✅ Get auth token
  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print("Token retrieved: $token");
    return token;
  }

  // ✅ Dialog pilihan kamera/galeri
  void _showImagePickerOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pick an Image"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("Take a Photo"),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Choose from Gallery"),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ Ambil foto dari kamera/galeri
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  // ✅ Register wajah dengan upload (pakai compressed)
  Future<void> _registerFace() async {
    final token = await _getAuthToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token is missing, please log in again.')),
      );
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected for registration.')),
      );
      return;
    }

    // Compress gambar sebelum upload
    final compressedImage = await compressImage(_imageFile!);

    final uri = Uri.parse('https://presence.guestallow.com/api/users/face');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = 'Bearer $token';

    final photo = await http.MultipartFile.fromPath(
      'photo',
      compressedImage.path,
      contentType: MediaType('image', 'jpeg'),
    );

    request.files.add(photo);

    print("Request Headers: ${request.headers}");

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      print('Face registration response: ${responseData.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Face registration successful')),
      );
    } else {
      final responseData = await http.Response.fromStream(response);
      print('Error: ${responseData.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register face')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Recorder")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: _showImagePickerOptions,
              child: Text("Rekam Wajah Baru"),
            ),
            SizedBox(height: 20),
            _imageFile == null
                ? Text("No image selected.")
                : Image.file(_imageFile!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerFace,
              child: Text("Register Face"),
            ),
          ],
        ),
      ),
    );
  }
}
