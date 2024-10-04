import 'dart:convert';
import 'package:http/http.dart' as http;

class SaleService {
  final String baseUrl =
      'http://192.168.12.63:3000/sales'; // Update with your API URL

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
