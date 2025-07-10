import 'dart:io';
import 'package:dio/dio.dart';

class FaceApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://presence.guestallow.com/api',
    headers: {
      'Accept': 'application/json',
    },
  ));

  // Register face
  Future<Map<String, dynamic>> registerFace(
      File imageFile, String token) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'face.jpg',
      ),
    });

    try {
      final response = await _dio.post(
        '/users/face',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return {
        'status_code': response.statusCode,
        'message': response.data['message'],
        'data': response.data['data'],
      };
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }

  // Verify face
//   Future<Map<String, dynamic>> verifyFace({
//     required File imageFile,
//     required String identifier,
//     required String token,
//   }) async {
//     final formData = FormData.fromMap({
//       'photo': await MultipartFile.fromFile(
//         imageFile.path,
//         filename: 'face.jpg',
//       ),
//       'identifier': identifier,
//     });

//     try {
//       final response = await _dio.post(
//         '/users/verify-face',
//         data: formData,
//         options: Options(
//           headers: {'Authorization': 'Bearer $token'},
//         ),
//       );

//       return {
//         'status_code': response.statusCode,
//         'message': response.data['message'],
//         'data': response.data['data'],
//       };
//     } catch (e) {
//       throw Exception('Verification failed: $e');
//     }
//   }

  Future<Map<String, dynamic>> verifyFace({
    required File imageFile,
    required String identifier,
    required String token,
  }) async {
    final formData = FormData.fromMap({
      'photo':
          await MultipartFile.fromFile(imageFile.path, filename: 'face.jpg'),
      'identifier': identifier,
    });

    try {
      final response = await _dio.post(
        'http://presence.guestallow.com/api/users/verify-face',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return {
        'status_code': response.statusCode,
        'message': response.data['message'],
        'data': response.data['data'],
      };
    } on DioException catch (e) {
      // Cetak detail error ke log untuk debug
      print('DioException status: ${e.response?.statusCode}');
      print('DioException data: ${e.response?.data}');

      return {
        'status_code': e.response?.statusCode ?? 500,
        'message': e.response?.data?['message'] ??
            'Verification failed with status code ${e.response?.statusCode}',
      };
    } catch (e) {
      print('Exception: $e');
      return {
        'status_code': 500,
        'message': 'Verification failed: $e',
      };
    }
  }

  // Future<UserModel?> getUserMe() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');
  //   if (token == null) return null;

  //   final response = await http.get(
  //     Uri.parse('https://presence.guestallow.com/api/users/me'),
  //     headers: {
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     return UserModel.fromJson(data['user']);
  //   } else {
  //     return null;
  //   }
  // }
}
