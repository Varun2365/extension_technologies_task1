import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_events.dart';
import 'home_state.dart';
import '../repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc(this._homeRepository) : super(HomeInitial()) {


    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        final data = await _homeRepository.getHomeData();
        emit(HomeLoaded(
            name: data['name'],
            email: data['email'],
            employeeId: data['employeeId'],
            isCheckedIn: data['isCheckedIn'],
            isCheckedOut: data['isCheckedOut'],
            totalLeaves: data['totalLeaves'],
            totalPresentDays: data['totalPresentDays']));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });
  on<CheckInPressed>(
    (event, emit) async {
      if (state is HomeLoaded) {
        emit(HomeLoading());
        try {
          await _homeRepository.checkIn();
          add(LoadHomeData());
        } catch (e) {
          emit(HomeError(message: e.toString()));
        }
      }
    },
  );

  on<CheckOutPressed>(
    (event, emit) async {
      if (state is HomeLoaded) {
        emit(HomeLoading());
        try {
          await _homeRepository.checkOut();
          add(LoadHomeData());
        } catch (e) {
          emit(HomeError(message: e.toString()));
        }
      }
    },
  );
  }

}

