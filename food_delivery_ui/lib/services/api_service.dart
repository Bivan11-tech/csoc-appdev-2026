import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_constants.dart';

class ApiService {
  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "API Error ${response.statusCode}: ${response.body}",
    );
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await getHeaders(),
    );

    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body,) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await getHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body,) async {
    final response = await http.put(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await getHeaders(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: await getHeaders(),
    );

    return _handleResponse(response);
  }
}