import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/homepage/block.dart';
import 'package:logins/services/repository.dart';

import '../../models/homepage.dart';
import '../../services/api_provider.dart';
import 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  final Repository repository;

  HomepageBloc({required this.repository}) : super(HomepageInitial()) {
    on<AppHomeStarted>(_mapAppHomeStartedToState);

    on<CategoryButtonClicked>(_mapCategoryButtonClickedToState);

  }

  Future<void> _mapAppHomeStartedToState(
      AppHomeStarted event,
      Emitter<HomepageState> emit,
      ) async {
    emit(HomepageLoading());
    try {


      final CategoryRecipeData categoryRecipeData =
      await repository.apiProvider.fetchChecklists();
      final UserRecipeData userRecipeData =
      await repository.apiProvider.fetchWishlists();

      final List<ReceipeDetail> Userwishlist = userRecipeData.receipes;


      final List<Category> categories = categoryRecipeData.categories;
      final List<ReceipeDetail> receipes = categoryRecipeData.receipes;



      emit(HomepageLoaded(categories, receipes,wishlist: Userwishlist));
      print("hi1");

    } catch (error) {
      emit(HomepageError('Failed to fetch checklists'));
    }
  }






  Future<void> _mapCategoryButtonClickedToState(
      CategoryButtonClicked event,
      Emitter<HomepageState> emit,
      ) async {
    final Category clickedCategory = event.category;

    if (state is HomepageLoaded) {
      final HomepageLoaded currentState = state as HomepageLoaded;
      final List<Category> categories = currentState.checklists;

      emit(HomepageLoading());

      try {
        final List<ReceipeDetail> receipes = await repository.apiProvider
            .fetchRecipesForCategory(clickedCategory.categoryId);
        final UserRecipeData userRecipeData =
        await repository.apiProvider.fetchWishlists();

        for (ReceipeDetail receipe in receipes) {
          print('Recipe Name: ${receipe.receipeId}');
          print('Ingredients: ${receipe.servingQuantity}');
          // Add more properties as needed
        }


        emit(HomepageLoaded(
          categories,
          receipes,
          clickedCategory: clickedCategory,
          wishlist: userRecipeData.receipes ?? const [],
        ));


      } catch (error) {
        emit(HomepageError('Failed to fetch data'));
      }
    }
  }
}
