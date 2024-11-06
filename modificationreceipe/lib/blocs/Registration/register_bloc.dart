 import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/authentication/bloc.dart';
import 'package:logins/services/repository.dart';
import './bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Repository repository;


  RegisterBloc({required this.repository})
      : assert(repository != null),


        super(RegisterInitial()) {
    on<RegisterButtonPressedEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        final tokens = await repository.regsitration(
          username: event.username,
          password: event.password,
          password2: event.password2,
          email: event.email,
        );

        emit (RegisterSuccessfull());
        emit(RegisterInitial());
      } catch (error) {
        emit(RegisterFailure(error: error.toString()));
      }
    });
  }
}
