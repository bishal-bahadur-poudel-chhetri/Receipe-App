class Ingredient {
  final String ingredientName;
  final String ingredientUrl;
  final int? amount;
  final int? unit;

  Ingredient({
    required this.ingredientName,
    required this.ingredientUrl,
    this.amount,
    this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredientName: json['ingredient_id']['ingredient_name'],
      ingredientUrl: json['ingredient_id']['ingredient_url'],
      amount: json['amount'],
      unit: json['unit'],
    );
  }
}


class Recipe {
  final String receipeId;
  final List<Ingredient> receipeIngredients;
  final Categories category;
  final List<Procedure> procedureDetail;
  final User receipeUser;
  final String receipeTitle;
  final String description;
  final double prepTime;
  final double cookTime;
  final int servingQuantity;
  final String categoryImage;

  Recipe({
    required this.receipeId,
    required this.receipeIngredients,
    required this.category,
    required this.procedureDetail,
    required this.receipeUser,
    required this.receipeTitle,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servingQuantity,
    required this.categoryImage,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      receipeId: json['receipe_id'],
      receipeIngredients: List<Ingredient>.from(json['receipe_ingredients'].map((ingredient) => Ingredient.fromJson(ingredient))),
      category: Categories.fromJson(json['category_id']),
      procedureDetail: List<Procedure>.from(json['procedure_receipe'].map((procedure) => Procedure.fromJson(procedure))),
      receipeUser: User.fromJson(json['receipe_user_id']),
      receipeTitle: json['receipe_title'],
      description: json['Description'],
      prepTime: double.parse(json['Prep_time'].toString()),
      cookTime: double.parse(json['cook_time'].toString()),
      servingQuantity: json['serving_quantity'],
      categoryImage: json['categoryImage'],
    );
  }
}

class Categories {
  final String categoryName;

  Categories({required this.categoryName});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      categoryName: json['category_name'],
    );
  }
}

class Procedure {
  final int procedure_number;
  final String description;

  Procedure({required this.procedure_number, required this.description});

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      procedure_number: json['procedure_number'],
      description: json['description'],
    );
  }
}

class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final int followers_count;
  final int following_count;
  final String last_login;
  final String date_joined;
  final bool is_verified;
  final String profile_image;

  User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.followers_count,
    required this.following_count,
    required this.last_login,
    required this.date_joined,
    required this.is_verified,
    required this.profile_image,


  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      followers_count: json['followers_count'],
      following_count: json['following_count'],
      last_login: json['last_login'],
      date_joined: json['date_joined'],
      is_verified: json['is_verified'],
      profile_image: json['profile_image'],

    );
  }
}

class ProfileData {
  final List<User> profile;

  ProfileData(this.profile);
}