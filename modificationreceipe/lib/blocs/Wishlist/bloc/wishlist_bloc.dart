import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/Wishlist/bloc/wishlist_event.dart';
import 'package:logins/blocs/Wishlist/bloc/wishlist_state.dart';
import 'package:logins/blocs/homepage/block.dart';
import 'package:logins/services/repository.dart';

import '../../../models/homepage.dart';
import '../../../services/api_provider.dart';



class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final Repository repository;

  WishlistBloc({required this.repository}) : super(WishlistInitial()) {
    on<AppWishlistStarted>(_mapAppWishlistStartedToState);
    on<WishlistDeleted>(_mapAppWishlistDelete);
    on<WishlistAdded>(_mapAppWishlistAdded);

  }

  Future<void> _mapAppWishlistStartedToState(
      AppWishlistStarted event,
      Emitter<WishlistState> emit,
      ) async {
    emit(WishlistLoading());
    try {
      final UserRecipeData userRecipeData =
      await repository.apiProvider.fetchWishlists();
      final List<ReceipeDetail> receipes = userRecipeData.receipes;
      emit(WishlistLoaded(receipes));
    } catch (error) {
      emit(WishlistError('Failed to fetch checklists'));
    }
  }



  Future<void> _mapAppWishlistDelete(
      WishlistDeleted event,
      Emitter<WishlistState> emit,
      ) async {
    emit(WishlistLoading());
    try {

      await repository.apiProvider.DeleteWishlistRecipe(receipeUserId: event.uuid);


    } catch (error) {
      emit(WishlistError('Failed to fetch checklists'));
    }
  }

  Future<void> _mapAppWishlistAdded(
      WishlistAdded event,
      Emitter<WishlistState> emit,
      ) async {
    emit(WishlistLoading());
    try {
      print("ok now");
      await repository.apiProvider.Wishlistadd(uuid: event.uuid);
      print("ok now1");


    } catch (error) {
      emit(WishlistError('Failed to fetch checklists'));
    }
  }

}



