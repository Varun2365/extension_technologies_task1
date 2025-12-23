abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<Map<String, dynamic>> attendanceList;
  final List<Map<String, dynamic>> leaveList;
  final String? fromDate;
  final String? toDate;

  AttendanceLoaded(this.attendanceList, {this.leaveList = const [], this.fromDate, this.toDate});
}

class AttendanceError extends AttendanceState {
  final String message;

  AttendanceError(this.message);
}

