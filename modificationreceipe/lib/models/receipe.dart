class ReceipeDetail {
  String recipeTitle;
  String description;
  String prepTime;
  String cookTime;
  int servingQuantity;
  int recipeUserId;
  int categoryId;
  int? UnitName;
  int? Amount;

  ReceipeDetail({
    required this.recipeTitle,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servingQuantity,
    required this.recipeUserId,
    required this.categoryId,
    this.UnitName,
    this.Amount,

  });

  factory ReceipeDetail.fromJson(Map<String, dynamic> json) {
    return ReceipeDetail(
      recipeTitle: json['receipe_title'],
      description: json['Description'],
      prepTime: json['Prep_time'],
      cookTime: json['cook_time'],
      servingQuantity: json['serving_quantity'],
      recipeUserId: json['receipe_user_id'],
      categoryId: json['category_id'],
    );
  }
}

class UserRecipeData {
  List<ReceipeDetail> receipes;

  UserRecipeData(this.receipes);
}
