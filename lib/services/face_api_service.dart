import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FaceApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://209.145.52.1:8190/api',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data'
    },
  ));

  // Fungsi untuk mendaftar wajah
  Future<Map<String, dynamic>> registerFace(File imageFile) async {
    final formData = FormData.fromMap({
      'photo':
          await MultipartFile.fromFile(imageFile.path, filename: 'face.jpg'),
    });

    try {
      final response = await _dio.post('/users/face', data: formData);

      // Menyimpan respons sebagai Map
      if (response.statusCode == 200) {
        return {
          'status_code': response.statusCode,
          'message': response.data['message'],
          'data': response.data['data'],
        };
      } else {
        return {
          'status_code': response.statusCode,
          'message': 'Gagal mendaftar wajah'
        };
      }
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }

  // Fungsi untuk verifikasi wajah
  // Future<Map<String, dynamic>> verifyFace(
  //     File imageFile, String identifier) async {
  //   final formData = FormData.fromMap({
  //     'photo':
  //         await MultipartFile.fromFile(imageFile.path, filename: 'face.jpg'),
  //     'identifier': identifier,
  //   });

  //   try {
  //     final response = await _dio.post('/users/verify-face', data: formData);

  //     // Menyimpan respons sebagai Map
  //     if (response.statusCode == 200) {
  //       return {
  //         'status_code': response.statusCode,
  //         'message': response.data['message'],
  //         'data': response.data['data'],
  //       };
  //     } else {
  //       return {
  //         'status_code': response.statusCode,
  //         'message': 'Verifikasi gagal'
  //       };
  //     }
  //   } catch (e) {
  //     throw Exception('Verification failed: $e');
  //   }
  // }

  Future<bool> verifyFace(String faceImage) async {
    try {
      final response = await http.post(
        Uri.parse('https://presence.guestallow.com/api/face/verifyFace'),
        body: jsonEncode({
          'face_image': faceImage,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return true; // Successful response
      } else {
        // Log or show a meaningful error
        print('Error verifying face: ${response.body}');
        return false;
      }
    } catch (e) {
      // Catch any errors like network issues
      print('Error during face verification: $e');
      return false;
    }
  }
}
