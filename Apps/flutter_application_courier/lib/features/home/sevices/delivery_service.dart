import 'dart:convert';
import 'package:http/http.dart' as http;

class DeliveryService {
  static Future<Map<String, dynamic>> getStatistik(String courierId) async {
    final response = await http.get(
      Uri.parse("http://flutterproject-production.up.railway.app/api/statistik/$courierId"),
    );

    return jsonDecode(response.body);
  }
}