import 'package:flutter/material.dart';
import 'package:task_1_attendance/features/home/screens/home_screen.dart';
import 'app_routes.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/attendance/screens/attendance_list_screen.dart';
import '../features/leave/screens/leave_apply_screen.dart';
import '../features/leave/screens/leave_list_screen.dart';
import 'splash_screen.dart';


class AppRouter{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){

      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_)=> const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_)=> LoginScreen(),
          settings: settings,
        );

      case AppRoutes.signup:
        return MaterialPageRoute(
          builder: (_) => SignupScreen(),
          settings: settings,
        );
        
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_)=> HomeScreen(),
          settings: settings,
        );
        
      case AppRoutes.attendanceList:
        return MaterialPageRoute(
          builder: (_)=> AttendanceListScreen(),
          settings: settings,
        );
        
      case AppRoutes.leaveApply:
        return MaterialPageRoute(
          builder: (_)=> LeaveApplyScreen(),
          settings: settings,
        );
        
      case AppRoutes.leaveList:
        return MaterialPageRoute(
          builder: (_)=> LeaveListScreen(),
          settings: settings,
        );
        
      default :
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("Route Not Found : ${settings.name}"),
            ),
          ),
        );
    }
  }
}