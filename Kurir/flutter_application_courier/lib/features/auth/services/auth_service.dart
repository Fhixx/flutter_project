import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> login({
    required String nama,
    required String telepon,
  }) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": nama,
        "telepon": telepon,
      }),
    );

    return jsonDecode(response.body);
  }
}