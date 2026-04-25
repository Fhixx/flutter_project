import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/order_model.dart';
import '../models/courier_model.dart';

class ApiService {
  static const String baseUrl = "http://flutterproject-production.up.railway.app";

  // GET ORDERS DIPROSES
  static Future<List<OrderModel>> getOrders() async {
    final res = await http.get(Uri.parse("$baseUrl/orders/diproses"));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data.map<OrderModel>((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data orders");
    }
  }

  // GET COURIERS
  static Future<List<CourierModel>> getCouriers() async {
    final res = await http.get(Uri.parse("$baseUrl/couriers"));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data
          .map<CourierModel>((e) => CourierModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Gagal mengambil data kurir");
    }
  }

  // ASSIGN COURIER
  static Future<bool> assignCourier(int orderId, int courierId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/deliveries/"), 
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "order_id": orderId,
        "courier_id": courierId,
      }),
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    return res.statusCode == 200;
  }
}