import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/product_category_model.dart';

class ProductService {
  final String baseUrl = 'http://localhost:3000/categories'; // Your API URL

  // Fetch all categories
  Future<List<ProductCategory>> getCategories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => ProductCategory.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch a category by ID
  // Future<ProductCategory> getCategoryById(String id) async {
  //   final response = await http.get(Uri.parse('$baseUrl/$id'));

  //   if (response.statusCode == 200) {
  //     return ProductCategory.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load category');
  //   }
  // }

  // Create a new category
  Future<ProductCategory> createCategory(ProductCategory category) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 201) {
      return ProductCategory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create category');
    }
  }

  // // Update a category by ID
  // Future<ProductCategory> updateCategory(String id, ProductCategory category) async {
  //   final response = await http.put(
  //     Uri.parse('$baseUrl/$id'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(category.toJson()),
  //   );

  //   if (response.statusCode == 200) {
  //     return ProductCategory.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to update category');
  //   }
  // }

  // Delete a category by ID
  Future<void> deleteCategory(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete category');
    }
  }
}
