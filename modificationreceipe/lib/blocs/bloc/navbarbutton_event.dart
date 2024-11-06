import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NavbarbuttonEvent extends Equatable {
  const NavbarbuttonEvent();

  @override
  List<Object> get props => [];
}

class FloatingPressedEvent extends NavbarbuttonEvent {
  const FloatingPressedEvent();
}
