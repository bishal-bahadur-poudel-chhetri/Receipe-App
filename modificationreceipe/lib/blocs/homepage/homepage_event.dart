// homepage_event.dart
import 'package:logins/models/homepage.dart';

abstract class HomepageEvent {}

class AppHomeStarted extends HomepageEvent {}
class AppHomeStartedPopular extends HomepageEvent {}



class CategoryButtonClicked extends HomepageEvent {
  final Category category;

  CategoryButtonClicked(this.category);

  List<Object> get props => [category];
}
