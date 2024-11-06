import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {



}
class LoginSucess extends LoginState {



}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure({required this.error}) : super();
}
