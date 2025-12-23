import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_1_attendance/theme/colors.dart';
import 'package:task_1_attendance/widgets/text_field.dart';
import 'package:task_1_attendance/app/app_routes.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController idController= TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                Text(
                  "To Your Account",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                    child: SvgPicture.asset(
                  'assets/images/login.svg',
                  height: 240,
                )),
                SizedBox(
                  height: 50,
                ),
                AppTextField(
                    controller: idController,
                    label: "Email ID",
                    hint: "Enter Your Email ID",
                    icon: Icons.email),
                SizedBox(
                  height: 15,
                ),
                AppTextField(
                  controller: passwordController,
                  label: "Password",
                  hint: "Password",
                  icon: Icons.password,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.accent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 2,
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(
                                  LoginButtonPressed(
                                    email: idController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          },
                    icon: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ))
                        : const Icon(Icons.login, size: 20),
                    label: Text(isLoading ? 'Logging in...' : 'Login'),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont Have an Account? "),
                    InkWell(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, AppRoutes.signup);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: Text("Sign Up",
                        style: TextStyle(color: ColorPalette.accent,fontWeight: FontWeight.w600),),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }),
      ),)
    );
  }
}
