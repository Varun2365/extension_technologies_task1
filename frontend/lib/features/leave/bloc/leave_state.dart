abstract class LeaveState {}

class LeaveInitial extends LeaveState {}

class LeaveLoading extends LeaveState {}

class LeaveSuccess extends LeaveState {
  final String message;

  LeaveSuccess(this.message);
}

class LeaveListLoaded extends LeaveState {
  final List<Map<String, dynamic>> leaveList;

  LeaveListLoaded(this.leaveList);
}

class LeaveError extends LeaveState {
  final String message;

  LeaveError(this.message);
}

