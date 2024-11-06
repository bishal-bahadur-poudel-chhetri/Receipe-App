import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {



}
class RegisterSuccessfull extends RegisterState {}
class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure({required this.error}) : super();
}
