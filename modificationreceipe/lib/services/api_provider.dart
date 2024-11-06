import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logins/config/app_config.dart';
import 'package:logins/models/token.dart';
import 'package:logins/models/wishlist.dart';
import 'package:logins/services/repository.dart';

import '../models/Otp.dart';
import '../models/homepage.dart';
import '../models/receipeDetail.dart';
import 'package:http_parser/http_parser.dart' as http_parser;




class ApiProvider {
  static Future<Map<String, String>> authenticate(
      String username, String password) async {
    final loginUrl = '${AppConfig.api_url}/api/token/';
    final body = {"email": username, "password": password};
    final response = await http.post(Uri.parse(loginUrl), body: body);
    if (response.statusCode == 200) {
      final parse = json.decode(response.body);
      final String token = Token.fromJson(parse).token;
      final String refToken = Token.fromJson(parse).ref_token;
      return {'access_token': token, 'refresh_token': refToken};
    } else if (response.statusCode == 401) {
      final message = json.decode(response.body)['detail'];
      throw AuthenticationException(message);
    } else {
      throw Exception("Other error");
    }
  }

  static Future<Map<String, String>> registration(
      String username, String password,String password2,String email) async {
    final loginUrl = '${AppConfig.api_url}/api/register/';
    final body = {"username": username, "password": password, "password2": password2, "email": email};
    final response = await http.post(Uri.parse(loginUrl), body: body);
    if (response.statusCode == 200) {
      final parse = json.decode(response.body);
      final String token = Token.fromJson(parse).token;
      final String refToken = Token.fromJson(parse).ref_token;
      return {'access_token': token, 'refresh_token': refToken};
    } else if (response.statusCode == 401) {
      final message = json.decode(response.body)['detail'];
      throw AuthenticationException(message);
    } else {
      throw Exception("Other error");
    }
  }



  Future<CategoryRecipeData> fetchChecklists() async {
    try {
      final categoriesUrl = '${AppConfig.api_url}/api/categories/';
      final receipeUrl = '${AppConfig.api_url}/api/receipe/';
      final accessToken = await Repository().access_token();
      Uri categories_parse = Uri.parse(categoriesUrl);
      Uri receipe_parse = Uri.parse(receipeUrl);

      final categoriesResponse = await http.get(
        categories_parse,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final receipeResponse = await http.get(
        receipe_parse,
        headers: {'Authorization': 'Bearer $accessToken'},
      );


      if (categoriesResponse.statusCode == 200 &&
          receipeResponse.statusCode == 200) {
        final jsonBodyCategories = jsonDecode(categoriesResponse.body);
        final jsonBodyReceipe = jsonDecode(receipeResponse.body);


        final List<Category> categories = (jsonBodyCategories as List)
            .map((json) => Category.fromJson(json))
            .toList();

        final List<ReceipeDetail> receipes = (jsonBodyReceipe as List)
            .map((json) => ReceipeDetail.fromJson(json))
            .toList();

        return CategoryRecipeData(categories, receipes);
      } else {
        throw Exception('Failed to fetch checklists');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  Future<CategoryRecipeData> p_fetchChecklists() async {
    try {
      final categoriesUrl = '${AppConfig.api_url}/api/categories/';
      final receipeUrl = '${AppConfig.api_url}/api/receipe/';
      final accessToken = await Repository().access_token();
      Uri categories_parse = Uri.parse(categoriesUrl);
      Uri receipe_parse = Uri.parse(receipeUrl);

      final categoriesResponse = await http.get(
        categories_parse,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final receipeResponse = await http.get(
        receipe_parse,
        headers: {'Authorization': 'Bearer $accessToken'},
      );


      if (categoriesResponse.statusCode == 200 &&
          receipeResponse.statusCode == 200) {
        final jsonBodyCategories = jsonDecode(categoriesResponse.body);
        final jsonBodyReceipe = jsonDecode(receipeResponse.body);


        final List<Category> categories = (jsonBodyCategories as List)
            .map((json) => Category.fromJson(json))
            .toList();

        final List<ReceipeDetail> receipes = (jsonBodyReceipe as List)
            .map((json) => ReceipeDetail.fromJson(json))
            .toList();

        return CategoryRecipeData(categories, receipes);
      } else {
        throw Exception('Failed to fetch checklists');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }



  Future<UserRecipeData> fetchWishlists() async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/wishlist/';
      final accessToken = await Repository().access_token();
      Uri receipe_parse = Uri.parse(receipeUrl);

      final receipeResponse = await http.get(
        receipe_parse,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (receipeResponse.statusCode == 200) {
        final jsonBodyReceipe = jsonDecode(receipeResponse.body);
        final List<ReceipeDetail> receipes = (jsonBodyReceipe as List)
            .map((json) => ReceipeDetail.fromJson(json))
            .toList();
        return UserRecipeData(receipes);
      } else {
        throw Exception('Failed to fetch checklists');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  Future<ProfileData> fetchProfile() async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/userdetail/';
      final accessToken = await Repository().access_token();
      Uri receipeParse = Uri.parse(receipeUrl);

      final receipeResponse = await http.get(
        receipeParse,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (receipeResponse.statusCode == 200) {
        final jsonBodyReceipe = jsonDecode(receipeResponse.body);
        print(jsonBodyReceipe);

        if (jsonBodyReceipe is List) {
          final List<User> users = jsonBodyReceipe.map((json) => User.fromJson(json)).toList();

          final profile = ProfileData(users);
          return profile;
        } else {
          throw Exception('Response is not a valid list of users');
        }
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }



  Future<UserRecipeData> fetchChecklistsUser(String queryString) async {
    try {
      final receipeBaseUrl  = '${AppConfig.api_url}/api/receipe/';
      final accessToken = await Repository().access_token();
      final receipeUrl = queryString.isNotEmpty
          ? '$receipeBaseUrl?usertype=$queryString'
          : receipeBaseUrl;


      Uri receipe_parse = Uri.parse(receipeUrl);

      final receipeResponse = await http.get(
        receipe_parse,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (receipeResponse.statusCode == 200) {
        final jsonBodyReceipe = jsonDecode(receipeResponse.body);

        final List<ReceipeDetail> receipes = (jsonBodyReceipe as List)
            .map((json) => ReceipeDetail.fromJson(json))
            .toList();

        return UserRecipeData(receipes);
      } else {
        throw Exception('Failed to fetch checklists');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }




  Future<List<ReceipeDetail>> fetchRecipesForCategory(int categoryId) async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/receipe/';
      final accessToken = await Repository().access_token();
      final receipeResponse = await http.get(
        Uri.parse('$receipeUrl?category=$categoryId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (receipeResponse.statusCode == 200) {
        final jsonBody = jsonDecode(receipeResponse.body);
        final List<ReceipeDetail> receipes = (jsonBody as List)
            .map((json) => ReceipeDetail.fromJson(json))
            .toList();
        for (ReceipeDetail receipe in receipes) {
          print('Recipe ID: ${receipe.receipeId}');
          print('Title: ${receipe.receipeTitle}');
          // Add more properties as needed
          print('Ingredients: ${receipe.receipeId}');
          print('Serving Quantity: ${receipe.servingQuantity}');
          // Add more properties as needed
          print('---'); // Separator between recipes for better readability
        }

        return receipes;
      } else {
        throw Exception('Failed to fetch recipes for the category');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }





  Future<String> postRecipe({
    required String receipeTitle,
    required String description,
    required String prepTime,
    required String cookTime,
    required int servingQuantity,
    required int categoryId,
    required String imagePath, // Change the parameter type to String
  }) async {
    try {
      final recipeUrl = '${AppConfig.api_url}/api/receipedetail/';
      final accessToken = await Repository().access_token();

      var request = http.MultipartRequest('POST', Uri.parse(recipeUrl));
      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields['receipe_title'] = receipeTitle;
      request.fields['Description'] = description;
      request.fields['Prep_time'] = prepTime;
      request.fields['cook_time'] = cookTime;
      request.fields['serving_quantity'] = servingQuantity.toString();
      request.fields['category_id'] = categoryId.toString();

      // Read the image file from the provided image path
      final File categoryImageFile = File(imagePath);
      print(categoryImageFile);
      var imageFile = http.MultipartFile(
        'categoryImage',
        categoryImageFile.readAsBytes().asStream(),
        categoryImageFile.lengthSync(),
        filename: 'IMG_20230808_100543.jpg',
        contentType: http_parser.MediaType('image', 'jpeg'),
      );
      request.files.add(imageFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final responseMap = jsonDecode(response.body);
        String receipeId = responseMap['receipe_id'];
        return receipeId;
      } else {
        throw Exception('Failed to post recipe');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }




  Future<void> DeleteRecipe({required String receipeUserId}) async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/receipedetail/';
      final accessToken = await Repository().access_token();
      final receipeResponse = await http.delete(
        Uri.parse('$receipeUrl$receipeUserId'),
        headers: {
          'Authorization': 'Bearer $accessToken',

        },
      );

      if (receipeResponse.statusCode == 204) {
        print("deleted success");

      } else {
        throw Exception('Failed to fetch checklists');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }


  Future<void> DeleteWishlistRecipe({required String receipeUserId}) async {
    try {

      final receipeUrl = '${AppConfig.api_url}/api/wishlist/';
      final accessToken = await Repository().access_token();
      final receipeResponse = await http.delete(
        Uri.parse('$receipeUrl$receipeUserId/'),
        
        headers: {
          'Authorization': 'Bearer $accessToken',

        },
      );
      print('$receipeUrl$receipeUserId');
      print(receipeResponse.statusCode);
      if (receipeResponse.statusCode == 204) {
        print("deleted success");

      } else {
        throw Exception('Failed to fetch checklists');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }


  Future<Map<String, dynamic>> checkFollowStatus(String followeeUsername) async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/follow';
      final accessToken = await Repository().access_token();
      final response = await http.get(
        Uri.parse('$receipeUrl?user=$followeeUsername'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        return responseData;
      } else {
        throw Exception('Failed to check follow status');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  Future<void> updateRecipe(Map<String, dynamic> data) async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/receipedetail/';
      final accessToken = await Repository().access_token();
      final receipeResponse = await http.put(
        Uri.parse('$receipeUrl${data["receipe_id"]}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );
      print("ok22");
      print(receipeResponse.statusCode);
      print(json.encode(data));

      if (receipeResponse.statusCode == 200) {
        print("updated success");
      } else {
        throw Exception('Failed to update recipe');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }



  Future<void> follow({required String followingUser,required String status}) async {
    try {
      print(followingUser);
      print(status);
      if(status=="follow"){
        final receipeUrl = '${AppConfig.api_url}/api/follow/';
        final accessToken = await Repository().access_token();

        final receipeResponse = await http.post(
          Uri.parse('$receipeUrl'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
          body: {
            "user": followingUser
          },

        );
        print("created success");

        if (receipeResponse.statusCode == 201) {
          print("deleted success");
        }


      }
      else if(status=="unfollow"){
        final receipeUrl = '${AppConfig.api_url}/api/follow/';
        final accessToken = await Repository().access_token();

        final receipeResponse = await http.delete(
          Uri.parse('$receipeUrl'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
          body: {
            "follower": followingUser
          },

        );
        print("created success");

        if (receipeResponse.statusCode == 201) {
          print("deleted success");
        }


      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }


  Future<void> OTP() async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/otp/';
      final accessToken = await Repository().access_token();
      final receipeResponse = await http.get(
        Uri.parse('$receipeUrl'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      print(receipeResponse.statusCode);
      if (receipeResponse.statusCode == 200) {
        print("otp send");
      } else {
        throw Exception('Failed to fetch checklists');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  Future<Map<String, String>> verifyOTP({required int userOtp}) async {
    try {
      print(userOtp);
      final receipeUrl = '${AppConfig.api_url}/api/verifyotp/';
      final accessToken = await Repository().access_token();
      final VerifyOtp = await http.post(
        Uri.parse('$receipeUrl'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'userotp': '$userOtp'
        },
      );
      final parse = json.decode(VerifyOtp.body);

      if (VerifyOtp.statusCode == 200) {
        return {'detail': Otp.fromJson(parse).detail,'status': Otp.fromJson(parse).status.toString()};
      } else if(VerifyOtp.statusCode == 404) {
        print(VerifyOtp.statusCode);
        return {'detail': Otp.fromJson(parse).detail,'status': Otp.fromJson(parse).status.toString()};
      }
      else {
        return {'detail': 'Default Detail', 'status': 'Default Status'};
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  Future<Map<String, String>> Wishlistadd({required String uuid}) async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/wishlist/';
      final accessToken = await Repository().access_token();
      final wishlistuuid = await http.post(
        Uri.parse('$receipeUrl'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          "uuid": '$uuid',
        },
      );
      print(wishlistuuid.statusCode);

      if (wishlistuuid.statusCode == 200) {
        // Check the content type
        final contentType = wishlistuuid.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          final parse = json.decode(wishlistuuid.body);
          if (parse is Map<String, dynamic>) {
            return {'detail': Wishlist.fromJson(parse).detail};
          } else {
            throw Exception('Response is not a valid JSON object');
          }
        } else {
          throw Exception('Invalid content type in the response');
        }
      } else {
        throw Exception('Failed to fetch checklists');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }


  Future<bool> Changepassword({required String oldpassword, required String newpassword}) async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/changepassword/';
      final accessToken = await Repository().access_token();
      final changepassword = await http.post(
        Uri.parse('$receipeUrl'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          "old_password": '$oldpassword',
          "new_password": '$newpassword',
        },
      );
      print(changepassword.statusCode);

      if (changepassword.statusCode == 200) {
        // Password change successful
        return true;
      } else {
        // Password change failed
        return false;
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }


  Future<Verification> check_verification() async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/check/';
      final accessToken = await Repository().access_token();
      final VerifyOtp = await http.get(
        Uri.parse('$receipeUrl'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final statusCode = VerifyOtp.statusCode;
      final parse = json.decode(VerifyOtp.body);

      if (statusCode == 200) {
        final result = parse['result'] as bool; // Assuming 'result' is a key in your JSON

        if (result) {
          // Handle the case when status code is 200 and result is true
          return Verification(
            status: parse['status'] as int,
            result: result,
          );
        } else {
          // Handle the case when status code is 200 and result is false
          // Add your specific handling for this case
          return Verification(status: 0, result: false);
        }
      } else if (statusCode == 404) {
        // Handle the case when status code is 404
        return Verification(status: 0, result: false);
      } else {
        // Handle other cases
        return Verification(status: 0, result: false);
      }
    } catch (error) {
      print('Error occurred: $error');
      throw Exception('An error occurred: $error');
    }
  }









  Future<List<Recipe>> fetchSingleRecipesData(String categoryId) async {
    try {
      final receipeUrl = '${AppConfig.api_url}/api/receipedetail';

      final accessToken = await Repository().access_token();
      final receipeResponse = await http.get(
        Uri.parse('$receipeUrl/$categoryId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      print(receipeResponse.statusCode);

      if (receipeResponse.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonBody =
              json.decode(receipeResponse.body);
          final Recipe recipes = Recipe.fromJson(jsonBody);

          return [recipes];
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to parse recipe data');
        }
      } else {
        throw Exception('Failed to fetch recipes for the category');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() {
    return '$message';
  }
}

class CategoryRecipeData {
  final List<Category> categories;
  final List<ReceipeDetail> receipes;

  CategoryRecipeData(this.categories, this.receipes);
}

class UserRecipeData {
  final List<ReceipeDetail> receipes;

  UserRecipeData(this.receipes);
}
class ProfileData {
  final List<User> profile;

  ProfileData(this.profile);
}