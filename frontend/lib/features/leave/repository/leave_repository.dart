import '../services/leave_service.dart';

class LeaveRepository {
  final LeaveService _service;

  LeaveRepository(this._service);

  Future<void> applyLeave({
    required String fromDate,
    required String toDate,
    required String type,
    required String reason,
  }) async {
    return await _service.applyLeave(
      fromDate: fromDate,
      toDate: toDate,
      type: type,
      reason: reason,
    );
  }

  Future<List<Map<String, dynamic>>> getLeaveList() async {
    return await _service.getLeaveList();
  }
}

