import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static const baseUrl = "http://flutterproject-production.up.railway.app/orders/";

  static Future<void> confirmPayment(int orderId) async {
    final res = await http
        .put(
          Uri.parse("${baseUrl}confirm/$orderId"),
          headers: {
            "Accept": "application/json",
          },
        )
        .timeout(const Duration(seconds: 10));

    print("CONFIRM STATUS: ${res.statusCode}");
    print("CONFIRM BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Gagal konfirmasi: ${res.body}");
    }
  }

  static Future<Map<String, dynamic>> createOrder({
    required int userId,
    required int productId,
    required int qty,
    required String address,
    required String paymentMethod,
    required String note,
  }) async {
    final res = await http
        .post(
          Uri.parse(baseUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            "user_id": userId,
            "product_id": productId,
            "qty": qty,
            "alamat_kirim": address,
            "metode": paymentMethod,
            "catatan": note,
          }),
        )
        .timeout(const Duration(seconds: 10));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    if (res.body.isEmpty) {
      throw Exception("Response kosong dari server");
    }

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Gagal membuat order: ${res.body}");
    }

    try {
      return jsonDecode(res.body);
    } catch (e) {
      throw Exception("Response bukan JSON: ${res.body}");
    }
  }
}