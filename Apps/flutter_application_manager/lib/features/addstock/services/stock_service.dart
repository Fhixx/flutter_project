import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService {
  static const String baseUrl = "https://flutterproject-production.up.railway.app";

  static Future<bool> addStock({
    required int productId,
    required int qty,
    required String tipe,
    required String keterangan,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/stock/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "product_id": productId,
        "qty": qty,
        "tipe": tipe,
        "keterangan": keterangan,
      }),
    );

     print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    
    return response.statusCode == 200;
  }
}