abstract class AuthEvent {}

class LoginButtonPressed extends AuthEvent{
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});
}

class SignupButtonPressed extends AuthEvent{

  final String name;
  final String email;
  final String password;
  final String employeeId;

  SignupButtonPressed({
    required this.email,
    required this.name,
    required this.password,
    required this.employeeId,
  });

}