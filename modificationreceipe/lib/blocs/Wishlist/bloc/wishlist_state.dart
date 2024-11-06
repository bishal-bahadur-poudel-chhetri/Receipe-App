import 'package:logins/models/homepage.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoad extends WishlistState {}


class WishlistLoaded extends WishlistState {
  final List<ReceipeDetail> receipe;

  WishlistLoaded(this.receipe);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WishlistLoaded &&
              runtimeType == other.runtimeType &&
              receipe == other.receipe;


  @override
  int get hashCode => receipe.hashCode;

  @override
  String toString() {
    return 'HomepageLoaded{receipe: $receipe}';
  }
}

class WishlistError extends WishlistState {
  final String errorMessage;

  WishlistError(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WishlistError &&
              runtimeType == other.runtimeType &&
              errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;

  @override
  String toString() {
    return 'HomepageError{errorMessage: $errorMessage}';
  }
}
