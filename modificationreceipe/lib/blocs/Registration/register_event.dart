import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterButtonPressedEvent extends RegisterEvent {
  final String username;
  final String password;
  final String password2;
  final String email;

  const RegisterButtonPressedEvent({
    required this.username,
    required this.password,
    required this.password2,
    required this.email,
  });

  @override
  List<Object> get props => [username, password,password2,email];
}
