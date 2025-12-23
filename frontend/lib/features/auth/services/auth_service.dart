import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_1_attendance/core/api_config.dart';
import 'package:task_1_attendance/core/storage_service.dart';

class AuthService {
  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty) {
      throw Exception('Email is required');
    }
    if (password.trim().isEmpty) {
      throw Exception('Password is required');
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password.trim(),
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout. Please check your connection.');
        },
      );

      final responseBody = response.body;

      if (response.statusCode != 201) {
        try {
          final errorData = jsonDecode(responseBody);
          final errorMessage = errorData['error']?.toString() ?? 'Login failed';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) rethrow;
          throw Exception('Login failed (${response.statusCode}): $responseBody');
        }
      }

      Map<String, dynamic> data;
      try {
        data = jsonDecode(responseBody);
      } catch (e) {
        throw Exception('Invalid response format: Failed to parse JSON');
      }

      if (data.containsKey('error')) {
        final errorMessage = data['error']?.toString() ?? 'Login failed';
        throw Exception(errorMessage);
      }

      final token = data['token'];
      if (token == null || token.toString().trim().isEmpty) {
        throw Exception('Token not received from server');
      }

      await StorageService.saveToken(token.toString());
      
      await StorageService.saveUserData({
        'name': data['name']?.toString() ?? '',
        'email': data['email']?.toString() ?? '',
        'employeeId': data['employeeId']?.toString() ?? '',
      });
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> signup(String name, String email, String password, String employeeId) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty || employeeId.trim().isEmpty) {
      throw Exception('All fields are required');
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim(),
          'password': password.trim(),
          'employeeId': employeeId.trim(),
        }),
      );

      final responseBody = response.body;
      
      if (response.statusCode == 201) {
        try {
          final data = jsonDecode(responseBody);
          final token = data['token'];
          if (token != null && token.toString().isNotEmpty) {
            await StorageService.saveToken(token.toString());
            final user = data['user'];
            if (user != null) {
              await StorageService.saveUserData({
                'name': user['name']?.toString() ?? '',
                'email': user['email']?.toString() ?? '',
                'employeeId': user['employeeId']?.toString() ?? '',
              });
            }
          } else {
            throw Exception('Token not received in response');
          }
        } catch (e) {
          throw Exception('Failed to parse response: ${e.toString()}');
        }
      } else {
        try {
          final errorData = jsonDecode(responseBody);
          final errorMessage = errorData['error']?.toString() ?? 'Signup failed';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Signup failed (${response.statusCode}): $responseBody');
        }
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }
}
