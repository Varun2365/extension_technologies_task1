import '../../home/services/attendance_service.dart';

class AttendanceRepository {
  final AttendanceService _service;

  AttendanceRepository(this._service);

  Future<List<Map<String, dynamic>>> getAttendanceList(
    String? from,
    String? to,
  ) async {
    return await _service.getAttendanceList(from, to);
  }
}

