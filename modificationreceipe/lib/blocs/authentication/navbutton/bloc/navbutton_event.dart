import 'package:flutter_bloc/flutter_bloc.dart';

// Define the events for the bottom navigation bar
abstract class BottomNavBarEvent {}

class TabSelectedEvent extends BottomNavBarEvent {
  final int selectedIndex;

  TabSelectedEvent(this.selectedIndex);
}

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, int> {
  BottomNavBarBloc() : super(0);

  @override
  Stream<int> mapEventToState(BottomNavBarEvent event) async* {
    if (event is TabSelectedEvent) {
      yield event.selectedIndex;
    }
  }
}
