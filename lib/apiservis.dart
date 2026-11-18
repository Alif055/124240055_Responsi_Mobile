import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';
  static Future<List<Product>> getProducts() async {
    final res = await http.get(Uri.parse('$_baseUrl/'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat produk (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as List;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Product> getProduct(int id) async {
    final res = await http.get(Uri.parse('$_baseUrl/$id'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat produk dengan id $id');
    }
    return Product.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
