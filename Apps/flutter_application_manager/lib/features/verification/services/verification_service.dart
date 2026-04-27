import 'dart:convert';
import 'package:http/http.dart' as http;

class VerificationService {
  static const baseUrl = "https://flutterproject-production.up.railway.app";

  /// ambil pesanan menunggu verifikasi
  static Future<List> getOrders() async {
    final response = await http.get(
      Uri.parse("$baseUrl/orders/pending"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  /// approve
  static Future<bool> approve(int orderId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/orders/approve/$orderId"),
    );

    return response.statusCode == 200;
  }

  /// reject
  static Future<bool> reject(int orderId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/orders/reject/$orderId"),
    );

    return response.statusCode == 200;
  }
}