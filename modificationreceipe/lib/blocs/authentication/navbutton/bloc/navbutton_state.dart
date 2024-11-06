import 'package:flutter_bloc/flutter_bloc.dart';

// Define the events for the bottom navigation bar
abstract class BottomNavBarEvent {}

class TabSelectedEvent extends BottomNavBarEvent {
  final int selectedIndex;

  TabSelectedEvent(this.selectedIndex);
}

// Define the states for the bottom navigation bar
abstract class BottomNavBarState {}

class TabSelectedState extends BottomNavBarState {
  final int selectedIndex;

  TabSelectedState(this.selectedIndex);
}

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  BottomNavBarBloc() : super(TabSelectedState(0));

  @override
  Stream<BottomNavBarState> mapEventToState(BottomNavBarEvent event) async* {
    if (event is TabSelectedEvent) {
      yield TabSelectedState(event.selectedIndex);
    }
  }
}
