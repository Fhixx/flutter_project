import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> login({
    required String nama,
    required String telepon,
  }) async {
    final response = await http.post(
      Uri.parse("https://flutterproject-production.up.railway.app/api/login/kurir"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": nama,
        "telepon": telepon,
      }),
    );

    return jsonDecode(response.body);
  }
}