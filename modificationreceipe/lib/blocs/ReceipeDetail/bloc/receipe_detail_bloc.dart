import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../models/homepage.dart';
import '../../../models/receipeDetail.dart';
import '../../../pages/ReceipeDetail/single_receipe_detail.dart';
import '../../../pages/createReceipe/addReceipe.dart';
import '../../../pages/createReceipe/editReceipe.dart';
import '../../../pages/profile/profile.dart';
import '../../../services/api_provider.dart';
import '../../../services/repository.dart';

import './bloc.dart';

import 'package:flutter/material.dart';

class ReceipeDetailBloc extends Bloc<ReceipeDetailEvent, ReceipeDetailState> {
  final Repository repository;
  final BuildContext context;
  static String? selectedReceipeId; // Make it static
  static String? selectedUser; // Make it static

  ReceipeDetailBloc({required this.repository, required this.context})
      : super(ReceipeDetailInitial()) {

    on<ReceipeButtonClicked>(_mapCategoryButtonClicked);
    on<AppReceipeDetailStarted>(_mapAppStarted);
    on<AppReceipeDetailStarted_edit>(_mapAppStartedEdit);

    on<ReceipeDetailLoadeds>(_mapAppStarted_test);


    on<ReceipeDetailPut>(_mapAppStartededit);
    on<AppReceipeUserDetailStarted>(_mapAppHomeUserStartedToState);
    on<ReceipeDetailPost>(_mapAppStartedPost);
    on<ReceipeDetailDelete>(_mapAppStartedDelete);
    on<ReceipeDetailUserFollow>(_mapAppStartededFollow);
  }

  Future<void> _mapCategoryButtonClicked(
      ReceipeButtonClicked event,
      Emitter<ReceipeDetailState> emit,
      ) async {
    final ReceipeDetail receipeId = event.receipeID;
    selectedReceipeId = receipeId.receipeId;

    final ReceipeDetail receipeUser = event.receipeID;
    selectedUser = receipeId.receipeId;
    String butontype = event.buttontype;

    try {
      emit(ReceipeDetailLoading());

      if (selectedReceipeId != null && selectedReceipeId!.isNotEmpty) {
        if (butontype == "notdata") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RecipeDetailPage(recipeId: selectedReceipeId!),
            ),
          );
        } else if (butontype == "mydata") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditReceipePage(recipeId: selectedReceipeId!),
            ),
          );
        }

        emit(ReceipeDetailLoaded(receipeId));
      } else {
        emit(ReceipeDetailError('Recipe details not found'));
      }
    } catch (error) {
      emit(ReceipeDetailError('Failed to fetch recipe details'));
    }
  }

  Future<void> _mapAppStarted_test(
      ReceipeDetailLoadeds event,
      Emitter<ReceipeDetailState> emit,
      ) async {
    emit(ReceipeDetailLoading());

  }

  Future<void> _mapAppStartedEdit(
      AppReceipeDetailStarted_edit event,
      Emitter<ReceipeDetailState> emit,
      ) async {
    try {

      emit(ReceipeDetailLoading());
      final  recipeId = event.receipeid;

      if (recipeId != null && recipeId.isNotEmpty) {
        print("hi1");

        final List<Recipe> recipes =
        await repository.apiProvider.fetchSingleRecipesData(recipeId);

        final CategoryRecipeData categoryRecipeData =
        await repository.apiProvider.fetchChecklists();

        final List<ReceipeDetail> Userreceipes = categoryRecipeData.receipes;

        if (recipes.isNotEmpty) {
          emit(ReceipeDetailLoadingMain(recipes, Userreceipes));
        } else {
          emit(ReceipeDetailError('No recipes found'));
        }
      } else {
        emit(ReceipeDetailError('Recipe ID not found'));
      }
    } catch (error) {
      emit(ReceipeDetailError('Failed to fetch recipes'));
    }
  }


  Future<void> _mapAppStarted(
      AppReceipeDetailStarted event,
      Emitter<ReceipeDetailState> emit,
      ) async {
    try {
      emit(ReceipeDetailLoading());
      final String? recipeId = selectedReceipeId;

      if (recipeId != null && recipeId.isNotEmpty) {
        final List<Recipe> recipes =
        await repository.apiProvider.fetchSingleRecipesData(recipeId);

        final CategoryRecipeData categoryRecipeData =
        await repository.apiProvider.fetchChecklists();

        final List<ReceipeDetail> Userreceipes = categoryRecipeData.receipes;

        if (recipes.isNotEmpty) {
          emit(ReceipeDetailLoadingMain(recipes, Userreceipes));
        } else {
          emit(ReceipeDetailError('No recipes found'));
        }
      } else {
        emit(ReceipeDetailError('Recipe ID not found'));
      }
    } catch (error) {
      emit(ReceipeDetailError('Failed to fetch recipes'));
    }
  }

  Future<void> _mapAppHomeUserStartedToState(
      AppReceipeUserDetailStarted event,
      Emitter<ReceipeDetailState> emit,
      ) async {
    emit(ReceipeDetailLoading());
    try {
      String datatype = event.dataChoice;
      if (datatype.isNotEmpty) {
        final UserRecipeData userRecipeData =
        await repository.apiProvider.fetchChecklistsUser(datatype);
        final List<ReceipeDetail> receipes = userRecipeData.receipes;
        emit(ReceipeDetailLoadedUser(receipes));
      }
    } catch (error) {
      emit(ReceipeDetailError('Failed to fetch checklists'));
    }
  }

  Future<void> _mapAppStartededFollow(
      ReceipeDetailUserFollow event,
      Emitter<ReceipeDetailState> emit,
      ) async {
    try {
      if(event.status=="follow"){
        print("ReceipeDetailfollow");

        final ReceipeDetail = await repository.apiProvider.follow(
            followingUser: event.FollowingUser,
            status: event.status
        );
        print("ReceipeDetailfollow1");


      }

    } catch (error) {
      emit(ReceipeDetailError('Failed to fetch recipes'));
    }
  }

  Future<void> _mapAppStartededit(
      ReceipeDetailPut event,
      Emitter<ReceipeDetailState> emit,
      ) async {
    try {


      final List<Map<String, dynamic>> ingredients = [];


      for (int i = 0; i < event.ingredientQuantities.length; i++) {


        final ingredient =   {
          "ingredient_id": {
            "ingredient_name": event.ingredientNames[i],
          },
          "amount": event.ingredientQuantities[i],
          "unit":  event.ingredientMeasuerement[0] == "ML" ? 1 : event.ingredientMeasuerement[0] == "LTR" ? 2 : event.ingredientMeasuerement[0] == "GM" ? 3 : 2,
        };
        print("Measurement: ${event.ingredientMeasuerement[0]}");
        print("Unit: ${event.ingredientMeasuerement[0] == "ML" ? 1 : event.ingredientMeasuerement[0] == "LTR" ? 2 : event.ingredientMeasuerement[0] == "GM" ? 3 : 2}");

        ingredients.add(ingredient);
      }

      // Create the list of procedure details
      final List<Map<String, dynamic>> procedureDetails = [];
      for (int i = 0; i < event.methodDescriptions.length; i++) {
        final procedure = {
          "procedure_number":event.methodDescriptionsid[i],
          "description": event.methodDescriptions[i],

        };
        procedureDetails.add(procedure);
      }
      print(ingredients);


      final data = {
        "receipe_id": event.uid,
        "ingredient_receipe": ingredients,
        "receipe_ingredients": ingredients,
        "category_id": {
          "category_name": event.selectedCategories[0], // Use the first selected category
        },
        "procedure_receipe": procedureDetails,
        "receipe_title": event.title,
        "Description": event.decription,
        "Prep_time": event.time,
        "cook_time": event.time,
        "serving_quantity": event.serves,
      };
      print(data);
      await Repository().apiProvider.updateRecipe(data);

    } catch (error) {
      emit(ReceipeDetailError('Failed to update recipe'));
    }
  }


  Future<void> _mapAppStartedPost(
      ReceipeDetailPost event,
      Emitter<ReceipeDetailState> emit,
      ) async {
    try {
      final status= await repository.apiProvider.check_verification();
      if(status.result==true) {
        final ReceipeDetail = await repository.apiProvider.postRecipe(
          receipeTitle: event.receipeTitle,
          description: event.description,
          prepTime: event.prepTime,
          cookTime: event.cookTime,
          servingQuantity: event.servingQuantity,
          categoryId: event.categoryId,
          imagePath: event.imagePath,
        );


        if (ReceipeDetail != null) {
          print(ReceipeDetail);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditReceipePage(recipeId: ReceipeDetail!),
            ),
          );
        }
      }
      else{
        final snackBar = SnackBar(
          content: Text('Email address must be verified'),
          duration: Duration(seconds: 4), // Adjust the duration as needed
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(),
          ),
        );


      }
    } catch (error) {
      print('Error: $error');
      emit(ReceipeDetailError('Failed to fetch recipes'));
    }
  }

  Future<void> _mapAppStartedDelete(
      ReceipeDetailDelete event,
      Emitter<ReceipeDetailState> emit,
      ) async {
    try {
      final ReceipeDetail = await repository.apiProvider.DeleteRecipe(
        receipeUserId: event.receipeUserId,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    } catch (error) {
      print('Error: $error');
      emit(ReceipeDetailError('Failed to fetch recipes'));
    }
  }

  @override
  Stream<ReceipeDetailState> mapEventToState(
      ReceipeDetailEvent event,
      ) async* {
    // Handle events here...
  }
}
