
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/ReceipeDetail/bloc/receipe_detail_bloc.dart';
import 'package:logins/blocs/ReceipeDetail/bloc/receipe_detail_state.dart';
import 'package:logins/models/homepage.dart';

abstract class ReceipeDetailEvent {}

class AppReceipeDetailStarted extends ReceipeDetailEvent {}
class AppReceipeDetailStarted_edit extends ReceipeDetailEvent {
  final String receipeid;
  AppReceipeDetailStarted_edit(this.receipeid);
}
class ReceipeDetailLoadeds extends ReceipeDetailEvent {}

// class AppReceipeUserDetailStarted extends ReceipeDetailEvent {}
class AppReceipeUserDetailStarted extends ReceipeDetailEvent {
  final String dataChoice;
  AppReceipeUserDetailStarted(this.dataChoice);

}


class ReceipeButtonClicked extends ReceipeDetailEvent {
  ReceipeDetail receipeID;
  ReceipeDetail receipeUser;
  dynamic buttontype;

  ReceipeButtonClicked(this.receipeID,this.receipeUser,this.buttontype);

  List<Object> get props => [receipeID,receipeUser,buttontype];

  void dispatchAppStartedEvent(BuildContext context) {
    BlocProvider.of<ReceipeDetailBloc>(context).add(AppReceipeUserDetailStarted("other"));
  }

}

class ReceipeDetailDelete extends ReceipeDetailEvent {
  final String receipeUserId;

  ReceipeDetailDelete(this.receipeUserId);

  List<Object> get props => [receipeUserId];


}
class ReceipeDetailPut extends ReceipeDetailEvent {
  final String uid;
  final String title;
  final String serves;
  final String time;
  final String decription;
  final List<String> ingredientNames;
  final List<String> ingredientQuantities;
  final List<String> ingredientMeasuerement;
  final List<String> methodDescriptions;
  final List<int> methodDescriptionsid;

  final List<String>  categories;
  final List<String> selectedCategories;
  final List<String> unitValues;





  ReceipeDetailPut(this.uid,this.title,this.decription,this.serves,this.time,this.ingredientNames,this.ingredientQuantities,this.ingredientMeasuerement,this.methodDescriptions,this.methodDescriptionsid,this.categories,this.selectedCategories,this.unitValues);
}

class ReceipeDetailPost extends ReceipeDetailEvent {
  final String receipeTitle;
  final String description;
  final String prepTime;
  final String cookTime;
  final int servingQuantity;
  final int categoryId;
  final String imagePath;

  ReceipeDetailPost( {
    required this.receipeTitle,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servingQuantity,
    required this.categoryId,
    required this.imagePath
  });

}

class ReceipeDetailUserFollow extends ReceipeDetailEvent {
  final String FollowingUser;
  final String status;

  ReceipeDetailUserFollow(this.FollowingUser,this.status);

  List<Object> get props => [FollowingUser];


}
