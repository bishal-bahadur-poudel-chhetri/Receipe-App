import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {
  const AppStarted();

  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String ref_token;


  const LoggedIn({required this.token,required this.ref_token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthenticationEvent {
  const LoggedOut();

  @override
  String toString() => 'LoggedOut';
}
class Reset extends AuthenticationEvent {
  const Reset();

  @override
  String toString() => 'Reset';
}