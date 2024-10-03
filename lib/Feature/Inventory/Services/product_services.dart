import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/product_category_model.dart';

class ProductService {
  final String baseUrl = 'http://192.168.0.105:3000/categories'; // Your API URL

  // Fetch all categories
  Future<List<ProductCategory>> getCategories() async {
  List<ProductCategory> allCategories = [];
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
    },
  );

  if (response.statusCode == 200) {
    // Parse the response as a Map
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    
    // Assuming the list of categories is under the 'data' key or another key
    if (responseBody.containsKey('categories')) {
      List<dynamic> categoryList = responseBody['categories'];
      print(categoryList.toString());
      allCategories = categoryList.map((dynamic item) => ProductCategory.fromJson(item)).toList();
    } else {
      throw Exception('Data key not found in the response');
    }
  } else {
    throw Exception('Failed to load categories');
  }

  return allCategories;
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
