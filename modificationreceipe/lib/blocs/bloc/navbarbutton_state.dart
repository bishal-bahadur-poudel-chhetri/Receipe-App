import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NavbarbuttonState extends Equatable {
  const NavbarbuttonState();

  @override
  List<Object> get props => [];
}

class NavbarbuttonInitial extends NavbarbuttonState {}
