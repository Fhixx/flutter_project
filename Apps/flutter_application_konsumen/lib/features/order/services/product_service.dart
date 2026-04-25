import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const baseUrl = "http://flutterproject-production.up.railway.app/products";

  static Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse(baseUrl));

    final data = jsonDecode(res.body) as List;
    return data.map((e) => Product.fromJson(e)).toList();
  }
}

