

import '../services/attendance_service.dart';

class HomeRepository {
  final AttendanceService _attendanceService;

  HomeRepository(this._attendanceService);

  Future<Map<String, dynamic>> getHomeData() async {
    try {
      final employeeInfo = await _attendanceService.getEmployeeInfo();
      final todayStatus = await _attendanceService.getTodayAttendance();
      final summary = await _attendanceService.getAttendanceSummary();

      return {
        'name': employeeInfo['name'],
        'email': employeeInfo['email'],
        'employeeId': employeeInfo['employeeId'],
        'isCheckedIn': todayStatus['isCheckedIn'],
        'isCheckedOut': todayStatus['isCheckedOut'],
        'totalPresentDays': summary['totalPresentDays'],
        'totalLeaves': summary['totalLeaves'],
      };
    } catch (e) {
      throw Exception('Failed to fetch home data: ${e.toString()}');
    }
  }

 
  Future<void> checkIn() async {
    try {
      await _attendanceService.checkIn();
    } catch (e) {
      throw Exception('Check-In Failed: ${e.toString()}');
    }
  }

  
  Future<void> checkOut() async {
    try {
      await _attendanceService.checkOut();
    } catch (e) {
      throw Exception('Check-Out Failed: ${e.toString()}');
    }
  }
}
