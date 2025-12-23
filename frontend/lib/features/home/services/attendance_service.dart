import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_1_attendance/core/api_config.dart';
import 'package:task_1_attendance/core/storage_service.dart';

class AttendanceService {
  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'applicationjson',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> getEmployeeInfo() async {
    try {
      final userData = await StorageService.getUserData();
      if (userData != null) {
        return {
          'name': userData['name'] ?? 'Employee',
          'email': userData['email'] ?? '',
          'employeeId': userData['employeeId'] ?? '',
        };
      }
      return {
        'name': 'Employee',
        'email': '',
        'employeeId': '',
      };
    } catch (e) {
      return {
        'name': 'Employee',
        'email': '',
        'employeeId': '',
      };
    }
  }

  Future<Map<String, bool>> getTodayAttendance() async {
    try {
      final headers = await _getHeaders();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final response = await http.get(
        Uri.parse('${ApiConfig.attendanceListUrl}?from=$today&to=$today'),
        headers: headers,
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final records = data['records'] ?? [];
        if (records is List && records.isNotEmpty) {
          final todayRecord = records[0];
          return {
            'isCheckedIn': todayRecord['checkInTime'] != null,
            'isCheckedOut': todayRecord['checkOutTime'] != null,
          };
        }
      }
      return {'isCheckedIn': false, 'isCheckedOut': false};
    } catch (e) {
      return {'isCheckedIn': false, 'isCheckedOut': false};
    }
  }

  Future<Map<String, int>> getAttendanceSummary() async {
    try {
      final headers = await _getHeaders();
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      
      final attendanceResponse = await http.get(
        Uri.parse(
            '${ApiConfig.attendanceListUrl}?from=${startOfMonth.toIso8601String().split('T')[0]}&to=${now.toIso8601String().split('T')[0]}'),
        headers: headers,
      );

      int presentDays = 0;
      int leaveDays = 0;

      if (attendanceResponse.statusCode == 201) {
        final attendanceData = jsonDecode(attendanceResponse.body);
        final records = attendanceData['records'] ?? [];

        if (records is List) {
          for (var record in records) {
            if (record['checkInTime'] != null && record['checkOutTime'] != null) {
              presentDays++;
            }
          }
        }
      }

      try {
        final leaveResponse = await http.get(
          Uri.parse(ApiConfig.leaveListUrl),
          headers: headers,
        );

        if (leaveResponse.statusCode == 201) {
          final leaveData = jsonDecode(leaveResponse.body);
          final leaves = leaveData['leaves'] ?? [];

          if (leaves is List) {
            final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
            
            for (var leave in leaves) {
              final status = leave['status']?.toString().toLowerCase();
              if (status == 'approved') {
                final fromDateStr = leave['fromDate']?.toString();
                final toDateStr = leave['toDate']?.toString();
                
                if (fromDateStr != null && toDateStr != null) {
                  try {
                    DateTime from = DateTime.parse(fromDateStr);
                    DateTime to = DateTime.parse(toDateStr);
                    
                    from = DateTime(from.year, from.month, from.day);
                    to = DateTime(to.year, to.month, to.day);
                    
                    if (to.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
                        from.isBefore(monthEnd.add(const Duration(days: 1)))) {
                      final leaveStart = from.isBefore(startOfMonth) ? startOfMonth : from;
                      final leaveEnd = to.isAfter(monthEnd) ? monthEnd : to;
                      
                      if (leaveEnd.isAfter(leaveStart) || leaveEnd.isAtSameMomentAs(leaveStart)) {
                        final days = leaveEnd.difference(leaveStart).inDays + 1;
                        leaveDays += days;
                      }
                    }
                  } catch (e) {
                  }
                }
              }
            }
          }
        }
      } catch (e) {
      }

      return {
        'totalPresentDays': presentDays,
        'totalLeaves': leaveDays,
      };
    } catch (e) {
      return {'totalPresentDays': 0, 'totalLeaves': 0};
    }
  }

  Future<void> checkIn() async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse(ApiConfig.checkInUrl),
      headers: headers,
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Check-in failed');
    }
  }

  Future<void> checkOut() async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse(ApiConfig.checkOutUrl),
      headers: headers,
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Check-out failed');
    }
  }

  Future<List<Map<String, dynamic>>> getAttendanceList(
      String? from, String? to) async {
    try {
      final headers = await _getHeaders();
      String url = ApiConfig.attendanceListUrl;
      if (from != null && to != null) {
        url += '?from=$from&to=$to';
      }
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final records = data['records'] ?? [];
        if (records is List) {
          return List<Map<String, dynamic>>.from(records);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
