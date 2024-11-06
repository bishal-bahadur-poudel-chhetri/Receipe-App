import 'package:logins/models/homepage.dart';
import 'package:logins/models/receipeDetail.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoad extends UserState {}


class UserLoaded extends UserState {
  final List<User> receipe;

  UserLoaded(this.receipe);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserLoaded &&
              runtimeType == other.runtimeType &&
              receipe == other.receipe;


  @override
  int get hashCode => receipe.hashCode;

  @override
  String toString() {
    return 'HomepageLoaded{receipe: $receipe}';
  }
}

class UserError extends UserState {
  final String errorMessage;

  UserError(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserError &&
              runtimeType == other.runtimeType &&
              errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;

  @override
  String toString() {
    return 'HomepageError{errorMessage: $errorMessage}';
  }
}
