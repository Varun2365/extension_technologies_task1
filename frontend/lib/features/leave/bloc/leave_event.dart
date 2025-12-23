abstract class LeaveEvent {}

class ApplyLeave extends LeaveEvent {
  final String fromDate;
  final String toDate;
  final String type;
  final String reason;

  ApplyLeave({
    required this.fromDate,
    required this.toDate,
    required this.type,
    required this.reason,
  });
}

class LoadLeaveList extends LeaveEvent {}

