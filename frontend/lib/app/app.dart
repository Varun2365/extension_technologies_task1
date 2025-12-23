import 'package:flutter/material.dart';
import 'package:task_1_attendance/theme/app_theme.dart';
import 'app_router.dart';
import 'app_routes.dart';
import 'app_providers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainApp extends StatelessWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
      providers : AppProviders.allProviders,
      child: MaterialApp(
        theme: AppTheme.theme,
        debugShowCheckedModeBanner : false,
        title : 'Attendance App',
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}