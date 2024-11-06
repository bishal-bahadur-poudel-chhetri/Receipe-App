import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/authentication/bloc.dart';
import 'package:logins/services/repository.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Repository repository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.repository, required this.authenticationBloc})
      : assert(repository != null),
        assert(authenticationBloc != null),
        super(LoginInitial()) {
    on<LoginButtonPressedEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        final tokens = await repository.authenticate(
          username: event.username,
          password: event.password,
        );
        final String accessToken = tokens['access_token']!;
        final String refreshToken = tokens['refresh_token']!;
        authenticationBloc.add(LoggedIn(token: accessToken,ref_token: refreshToken));
        emit(LoginSucess());
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });

  }
}
