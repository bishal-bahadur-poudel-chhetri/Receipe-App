class Category {
  final int categoryId;
  final String categoryName;

  Category({required this.categoryId, required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }
}
class ReceipeDetail {
  String receipeId;
  ReceipeUser receipeUserId;
  String receipeTitle;
  String description;
  double prepTime;
  double cookTime;
  int servingQuantity;
  String categoryImage;
  int categoryId;

  ReceipeDetail({
    required this.receipeId,
    required this.receipeUserId,
    required this.receipeTitle,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servingQuantity,
    required this.categoryImage,
    required this.categoryId,
  });

  factory ReceipeDetail.fromJson(Map<String, dynamic> json) {
    return ReceipeDetail(
      receipeId: json['receipe_id'],
      receipeUserId: ReceipeUser.fromJson(json['receipe_user_id']),
      receipeTitle: json['receipe_title'],
      description: json['Description'],
      prepTime: double.parse(json['Prep_time'].toString()),
      cookTime: double.parse(json['cook_time'].toString()),
      servingQuantity: json['serving_quantity'],
      categoryImage: json['categoryImage'],
      categoryId: json['category_id'],
    );
  }
}

class ReceipeUser {
  String username;
  String email;
  String firstName;
  String lastName;
  int followers_count;
  int following_count;


  ReceipeUser({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.followers_count,
    required this.following_count
  });

  factory ReceipeUser.fromJson(Map<String, dynamic> json) {
    return ReceipeUser(
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      followers_count: json['followers_count'],
      following_count: json['following_count'],
    );
  }
}


class Verification {
  final int status;
  final bool result;

  Verification({
    required this.status,
    required this.result,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      status: json['status'] as int,
      result: json['result'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'result': result,
    };
  }
}
