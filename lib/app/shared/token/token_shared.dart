import 'package:shared_preferences/shared_preferences.dart';

class TokenShared {
  final _key = 'token-jwt';

  Future<bool> removeToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(_key);
  }

  Future<String?> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_key);
    return token;
  }

  Future<bool> setToken(String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isSuccess = await sharedPreferences.setString(_key, token);
    return isSuccess;
  }
}
