import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../pages/createReceipe/addReceipe.dart';
import '../../pages/createReceipe/editReceipe.dart';
import '../../pages/splash_page.dart';
import 'block.dart';
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(InitialNavigationState()) {
    on<NavigateToNewPageEvent>((event, emit) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (context) => AddReceipePage()),
      );

      emit(NewPageNavigationState());
    });
  }

}