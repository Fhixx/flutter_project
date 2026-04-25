import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const baseUrl = "http://flutterproject-production.up.railway.app/auth";

  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String alamat,
    required String telepon,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register/konsumen"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "alamat": alamat,
        "telepon": telepon,
      }),
    );

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login/konsumen"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    return jsonDecode(res.body);
  }
}
