import 'package:flutter/material.dart';
import 'package:task_1_attendance/core/storage_service.dart';
import 'package:task_1_attendance/theme/colors.dart';
import 'app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final token = await StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.accent,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Extension",style: TextStyle(color: Colors.white,fontSize: 40)),
            Text("Technologies",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w300)),
            SizedBox(height: 40,),
            CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

