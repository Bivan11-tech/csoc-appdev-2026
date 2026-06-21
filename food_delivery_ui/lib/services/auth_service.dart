import 'package:food_delivery_ui/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService api = ApiService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await api.post("/api/auth/login",
      {
        "email": email,
        "password": password,
      },
    );

    return data;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {

    final data = await api.post("/api/auth/register",
      {
        "name": name,
        "email": email,
        "password": password,
      },
    );

    return data;
  }

  Future<void> saveUserSession(
      String token,
      Map<String, dynamic> user,
      ) async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    await prefs.setString("userId", user["id"]);
    await prefs.setString("userName", user["name"]);
    await prefs.setString("userEmail", user["email"]);
    await prefs.setBool("isLoggedIn", true);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> updateProfile(String name) async {
    await api.put("/api/auth/profile",
      {
        "name": name,
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userName", name);
  }
}
