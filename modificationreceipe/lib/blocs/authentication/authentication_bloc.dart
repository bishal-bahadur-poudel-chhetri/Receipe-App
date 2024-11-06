import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:logins/blocs/authentication/authentication_event.dart';
import 'package:logins/blocs/authentication/authentication_state.dart';
import 'package:logins/services/repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Repository repository;

  AuthenticationBloc({required this.repository})
      : super(AuthenticationUninitialized()) {
    on<AppStarted>((event, emit) async {
      final bool hasToken = await repository.hasToken();
      print(hasToken);
      print("true");
      if (hasToken) {

        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationLoading());

      await repository.persistToken(event.token,event.ref_token);
      emit(AuthenticationAuthenticated());

    });

    on<LoggedOut>((event, emit) async {

      emit(AuthenticationLoading());
      await repository.deleteToken();
      emit(AuthenticationUnauthenticated());
    });

    on<Reset>((event, emit) {
      emit(AuthenticationUninitialized());
    });
  }
}
