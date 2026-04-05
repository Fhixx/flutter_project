import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const baseUrl = "http://10.0.2.2:8000/products";

  static Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse(baseUrl));

    final data = jsonDecode(res.body) as List;
    return data.map((e) => Product.fromJson(e)).toList();
  }
}

