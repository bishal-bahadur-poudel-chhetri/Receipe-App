// homepage_event.dart
import 'package:flutter/src/widgets/framework.dart';
import 'package:logins/models/homepage.dart';


abstract class NavigationEvent {}

class NavigateToNewPageEvent extends NavigationEvent {
  final BuildContext context;

  NavigateToNewPageEvent(this.context);
}
