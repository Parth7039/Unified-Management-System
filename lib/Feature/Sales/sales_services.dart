import 'dart:convert';
import 'package:http/http.dart' as http;

class SaleService {
  final String baseUrl =
      'http://localhost:3000/sales'; // Update with your API URL


      Future<List<Map<String, dynamic>>> getLatestSales() async {
    final url = Uri.parse('$baseUrl/latest'); // Adjust the endpoint as per your API design

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response into a list of sales
        List<dynamic> salesData = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(salesData);
      } else {
        throw Exception('Failed to fetch latest sales');
      }
    } catch (e) {
      print('Error fetching latest sales: $e');
      throw Exception('Failed to fetch latest sales');
    }
  }

  Future<void> createSale(String buyerName, String productId, int quantitySold,
      DateTime? dateOfPurchase) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'buyerName': buyerName,
        'productId': productId,
        'quantitySold': quantitySold,
        'dateOfPurchase': dateOfPurchase
            ?.toIso8601String(), // Convert DateTime to ISO format if provided
      }),
    );

    if (response.statusCode == 201) {
      // Sale recorded successfully
      print('Sale recorded: ${response.body}');
    } else {
      // Handle error response
      final errorResponse = jsonDecode(response.body);
      throw Exception('Failed to create sale: ${errorResponse['error']}');
    }
  }
}
