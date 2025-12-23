import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_1_attendance/features/home/bloc/home_bloc.dart';
import 'package:task_1_attendance/features/home/repository/home_repository.dart';
import 'package:task_1_attendance/features/home/services/attendance_service.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/attendance/bloc/attendance_bloc.dart';
import '../features/attendance/repository/attendance_repository.dart';
import '../features/leave/bloc/leave_bloc.dart';
import '../features/leave/repository/leave_repository.dart';
import '../features/leave/services/leave_service.dart';

class AppProviders {
  static final AttendanceService _attendanceService = AttendanceService();
  static final LeaveService _leaveService = LeaveService();
  
  static List<BlocProvider> get allProviders => [
    BlocProvider<AuthBloc>(create: (_)=> AuthBloc(),),
    BlocProvider<HomeBloc>(create: (_)=>HomeBloc(HomeRepository(_attendanceService))),
    BlocProvider<AttendanceBloc>(create: (_)=>AttendanceBloc(AttendanceRepository(_attendanceService), LeaveRepository(_leaveService))),
    BlocProvider<LeaveBloc>(create: (_)=>LeaveBloc(LeaveRepository(_leaveService))),
  ];
}