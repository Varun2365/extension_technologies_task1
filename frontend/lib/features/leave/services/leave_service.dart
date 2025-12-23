import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_1_attendance/core/api_config.dart';
import 'package:task_1_attendance/core/storage_service.dart';

class LeaveService {
  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'applicationjson',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> applyLeave({
    required String fromDate,
    required String toDate,
    required String type,
    required String reason,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse(ApiConfig.leaveApplyUrl),
      headers: headers,
      body: jsonEncode({
        'fromDate': fromDate,
        'toDate': toDate,
        'type': type,
        'reason': reason,
      }),
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to apply leave');
    }
  }

  Future<List<Map<String, dynamic>>> getLeaveList() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConfig.leaveListUrl),
        headers: headers,
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final leaves = data['leaves'] ?? [];
        if (leaves is List) {
          return List<Map<String, dynamic>>.from(leaves);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

