// homepage_event.dart
import 'package:logins/models/homepage.dart';

abstract class WishlistEvent {}

class AppWishlistStarted extends WishlistEvent {}

class WishlistDeleted  extends WishlistEvent{
  final String uuid;
  WishlistDeleted(this.uuid);
 }

class WishlistAdded  extends WishlistEvent{
  final String uuid;
  WishlistAdded(this.uuid);
}

