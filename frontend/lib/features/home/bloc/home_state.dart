abstract class HomeState{}

class HomeInitial extends HomeState{}

class HomeLoading extends HomeState{}

class HomeLoaded extends HomeState{
  final String name;
  final String email;
  final String employeeId;
  final bool isCheckedIn;
  final bool isCheckedOut;
  final int totalPresentDays;
  final int totalLeaves;

HomeLoaded({
  required this.name,
  required this.email,
  required this.employeeId,
  required this.isCheckedIn,
  required this.isCheckedOut,
  required this.totalLeaves,
  required this.totalPresentDays,
});

}

class HomeError extends HomeState{
  final String message;
  HomeError({
    required this.message
  });
}