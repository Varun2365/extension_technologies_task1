import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthService _authService = AuthService();

  AuthBloc() : super(AuthInitial()){

    on<LoginButtonPressed>((event, emit) async{
      emit(AuthLoading());
      try{
        await _authService.login(event.email , event.password);
        emit(AuthSuccess());
      }catch(e){
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.replaceFirst('Exception: ', '');
        }
        emit(AuthFailure(errorMessage));
      }
    },);

    on<SignupButtonPressed>((event,emit) async{
      emit(AuthLoading());
      try{
        await _authService.signup(event.name ,event.email ,event.password, event.employeeId);
        emit(AuthSuccess());
      }catch(e){
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(AuthFailure(errorMessage));
      }
    });

  }
}