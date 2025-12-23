import 'package:flutter_bloc/flutter_bloc.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';
import '../repository/attendance_repository.dart';
import '../../leave/repository/leave_repository.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _attendanceRepository;
  final LeaveRepository _leaveRepository;

  AttendanceBloc(this._attendanceRepository, this._leaveRepository) : super(AttendanceInitial()) {
    on<LoadAttendanceList>((event, emit) async {
      emit(AttendanceLoading());
      try {
        final attendanceList = await _attendanceRepository.getAttendanceList(
          event.from,
          event.to,
        );
        
        List<Map<String, dynamic>> leaveList = [];
        try {
          leaveList = await _leaveRepository.getLeaveList();
        } catch (e) {
        }
        
        emit(AttendanceLoaded(attendanceList, leaveList: leaveList, fromDate: event.from, toDate: event.to));
      } catch (e) {
        emit(AttendanceError(e.toString()));
      }
    });
  }
}

