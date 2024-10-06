import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/contract_model.dart'; // Assuming your Contract and Party models are in this file

class ContractService {
  static const String baseUrl =
      'http://localhost:3000'; // Replace with your actual API URL

  Future<List<Contract>> fetchContracts() async {
    final response =
        await http.get(Uri.parse('$baseUrl/contracts/get-all-contracts'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Contract> contracts =
          body.map((dynamic item) => Contract.fromJson(item)).toList();
      return contracts;
    } else {
      throw Exception('Failed to load contracts');
    }
  }

  Future<void> addContract(Contract contract) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contracts/add-contract'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(contract.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add contract');
    }
  }
}
