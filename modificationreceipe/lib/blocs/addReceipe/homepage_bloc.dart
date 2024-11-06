// homepage_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'block.dart';

class AddReceipeBloc extends Bloc<AddReceipeEvent, AddReceipeState> {
  AddReceipeBloc() : super(InitialNavigationState());

  @override
  Stream<AddReceipeState> mapEventToState(AddReceipeEvent event) async* {

    if (event is NavigateToNewPageEvent) {
      yield NewPageNavigationState();
    }
  }
}
