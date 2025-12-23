abstract class AttendanceEvent {}

class LoadAttendanceList extends AttendanceEvent {
  final String? from;
  final String? to;

  LoadAttendanceList({this.from, this.to});
}

