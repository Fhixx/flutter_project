import 'dart:convert';
import 'package:http/http.dart' as http;

class DeliveryService {
  static Future<Map<String, dynamic>> getStatistik(String courierId) async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/api/statistik/$courierId"),
    );

    return jsonDecode(response.body);
  }
}