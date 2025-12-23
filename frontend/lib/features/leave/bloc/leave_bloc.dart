import 'package:flutter_bloc/flutter_bloc.dart';
import 'leave_event.dart';
import 'leave_state.dart';
import '../repository/leave_repository.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final LeaveRepository _repository;

  LeaveBloc(this._repository) : super(LeaveInitial()) {
    on<ApplyLeave>((event, emit) async {
      emit(LeaveLoading());
      try {
        await _repository.applyLeave(
          fromDate: event.fromDate,
          toDate: event.toDate,
          type: event.type,
          reason: event.reason,
        );
        emit(LeaveSuccess('Leave applied successfully'));
      } catch (e) {
        emit(LeaveError(e.toString()));
      }
    });

    on<LoadLeaveList>((event, emit) async {
      emit(LeaveLoading());
      try {
        final list = await _repository.getLeaveList();
        emit(LeaveListLoaded(list));
      } catch (e) {
        emit(LeaveError(e.toString()));
      }
    });
  }
}

