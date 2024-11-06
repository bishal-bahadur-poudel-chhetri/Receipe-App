import 'package:logins/models/homepage.dart';

abstract class HomepageState {}

class HomepageInitial extends HomepageState {}

class HomepageLoading extends HomepageState {}

class HomepageLoaded extends HomepageState {
  final List<Category> checklists;
  final List<ReceipeDetail> receipe;
  final Category? clickedCategory;
  final List<ReceipeDetail>? wishlist;

  HomepageLoaded(this.checklists, this.receipe, {this.clickedCategory, this.wishlist});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HomepageLoaded &&
              runtimeType == other.runtimeType &&
              checklists == other.checklists &&
              receipe == other.receipe &&
              clickedCategory == other.clickedCategory;

  @override
  int get hashCode => checklists.hashCode ^ receipe.hashCode ^ clickedCategory.hashCode;

  @override
  String toString() {
    return 'HomepageLoaded{checklists: $checklists, receipe: $receipe, clickedCategory: $clickedCategory}';
  }
}



class HomepageError extends HomepageState {
  final String errorMessage;

  HomepageError(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HomepageError &&
              runtimeType == other.runtimeType &&
              errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;

  @override
  String toString() {
    return 'HomepageError{errorMessage: $errorMessage}';
  }
}
