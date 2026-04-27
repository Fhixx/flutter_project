import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

class ApiService {
  static const baseUrl = "https://flutterproject-production.up.railway.app";

  // GET ORDER
  static Future<List<OrderModel>> getCourierOrders(int courierId) async {
    final res = await http.get(Uri.parse("$baseUrl/courier-orders/$courierId"));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data.map<OrderModel>((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load order: ${res.body}");
    }
  }

  // UPDATE STATUS
  static Future<bool> updateStatus(int orderId, String status) async {
    final res = await http.put(
      Uri.parse("$baseUrl/courier-orders/$orderId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );

    final data = jsonDecode(res.body);
    return res.statusCode == 200 && data["success"] == true;
  }

  static Future<Map<String, dynamic>> getDetail(int orderId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/courier-orders/detail/$orderId"),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Gagal ambil detail");
    }
  }

  static Future<bool> pickup(int orderId) async {
    final res = await http.put(
      Uri.parse("$baseUrl/courier-orders/pickup/$orderId"),
    );
    final data = jsonDecode(res.body);
    return res.statusCode == 200 && data["success"] == true;
  }

  static Future<bool> finish(int orderId) async {
    final res = await http.put(
      Uri.parse("$baseUrl/courier-orders/finish/$orderId"),
    );
    final data = jsonDecode(res.body);
    return res.statusCode == 200 && data["success"] == true;
  }

  static Future<bool> bayarCOD(int orderId, int jumlah) async {
    final res = await http.put(
      Uri.parse("$baseUrl/courier-orders/cod/$orderId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"jumlah": jumlah}),
    );
    final data = jsonDecode(res.body);
    return res.statusCode == 200 && data["success"] == true;
  }
}
