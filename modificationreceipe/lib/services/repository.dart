import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logins/services/api_provider.dart';

class Repository {
  final storage = FlutterSecureStorage();
  final ApiProvider apiProvider = ApiProvider();

  Future<Map<String, String>> authenticate(
          {required String username, required String password}) =>
      ApiProvider.authenticate(username, password);

  Future<Map<String, String>> regsitration(
      {required String username, required String password,required String password2,required String email}) =>
      ApiProvider.registration(username, password, password2,email);




  Future<void> persistToken(String token,String ref_token) async {
    storage.write(key: "authToken", value: token);
    storage.write(key: "refreshToken", value: ref_token);
  }

  Future<bool> hasToken() async {
    String? token = await storage.read(key: "authToken");
    bool result = token != null ? true : false;
    return result;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: "authToken");
  }

  Future<String?> access_token() async {
    String? token = await storage.read(key: "authToken");
    if(token==null){
      return null;
    }
    return token;
  }



}
