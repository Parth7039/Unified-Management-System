import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/product_category_model.dart';
import '../Models/product_model.dart';

class ProductService {
  final String baseUrl = 'http://localhost:3000/categories'; // Your API URL

  // Fetch all products by category ID
  // Future<List<Product>> getProductsByCategory(String categoryId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/$categoryId/products'));

  //   if (response.statusCode == 200) {
  //     print(response.body);

  //     List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => Product.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/$categoryId/products'));

    if (response.statusCode == 200) {
      // Decode the response body as a map (object)
      // print(response.request);
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      // Check if the response was successful and contains products
      if (jsonResponse['success'] == true &&
          jsonResponse.containsKey('products')) {
        // Get the products list
        List<dynamic> productList = jsonResponse['products'];

        // Convert each product from JSON to Product object and return the list
        return productList.map((json) => Product.fromJson(json)).toList();
      } else {
        return []; // Return an empty list if no products are found
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch a single product by ID
  Future<Product> getProductById(String productId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$productId'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  // Create a new product
  Future<void> createProduct(Product product, String categoryId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$categoryId/products'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }
  }

  // Update an existing product
  Future<void> updateProduct(String productId, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$productId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  // Delete a product by ID
  Future<void> deleteProduct(String productId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/products/$productId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  Future<List<Product>> getAllProducts() async {
    List<Product> allProducts = [];
    final response = await http.get(
      Uri.parse('http://192.168.0.105:3000/inventory'),
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    );

    if (response.statusCode == 200) {
      // Decode the response
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody['products']);
      // Access the 'products' key which contains the list
      List<dynamic> productList = responseBody['products'];
      allProducts =
          productList.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }

    return allProducts;
  }
}
