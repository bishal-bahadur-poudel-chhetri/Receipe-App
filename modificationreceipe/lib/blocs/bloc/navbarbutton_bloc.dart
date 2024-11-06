import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import './bloc.dart';

class FloatingBloc extends Bloc<NavbarbuttonEvent, NavbarbuttonState> {
  FloatingBloc() : super(NavbarbuttonInitial()) {
    on<FloatingPressedEvent>((event, emit) {
      print("Floating button pressed");
      // Add your desired functionality here
    });
  }
}
