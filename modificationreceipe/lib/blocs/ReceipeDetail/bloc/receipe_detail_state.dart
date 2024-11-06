import 'package:meta/meta.dart';
import 'package:logins/models/receipeDetail.dart';

import '../../../models/homepage.dart';

@immutable
abstract class ReceipeDetailState {}

class ReceipeDetailInitial extends ReceipeDetailState {}

class ReceipeDetailLoading extends ReceipeDetailState {}



class ReceipeDetailLoaded extends ReceipeDetailState {
  final ReceipeDetail receipeDetail;

  ReceipeDetailLoaded(this.receipeDetail);
}

class ReceipeDetailLoadingMain extends ReceipeDetailState {
  final List<Recipe> recipes;
  final List<ReceipeDetail> receipeList;

  ReceipeDetailLoadingMain(this.recipes,this.receipeList);
}
class ReceipeDetailLoadedUser extends ReceipeDetailState {
  final List<ReceipeDetail> recipes;

  ReceipeDetailLoadedUser(this.recipes);
}




class ReceipeDetailError extends ReceipeDetailState {
  final String errorMessage;

  ReceipeDetailError(this.errorMessage);
}
