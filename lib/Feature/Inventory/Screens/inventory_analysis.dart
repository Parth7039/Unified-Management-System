import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class InventoryPieChart extends StatefulWidget {
  @override
  _InventoryPieChartState createState() => _InventoryPieChartState();
}

class _InventoryPieChartState extends State<InventoryPieChart> {
  List<InventoryData> inventoryData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchInventoryData();
  }

  Future<void> fetchInventoryData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.105:3000/inventory/analysis'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse.toString());
        
        // Convert JSON data to List<InventoryData>
        setState(() {
          inventoryData = jsonResponse.map((data) => InventoryData(data['name'], data['quantity'])).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load inventory data');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Distribution'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : _buildPieChart());
  }

  Widget _buildPieChart() {
    double totalQuantity = inventoryData.fold(0, (sum, item) => sum + item.quantity);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCircularChart(
        title: ChartTitle(text: 'Inventory Distribution'),
        legend: Legend(isVisible: true),
        series: <CircularSeries>[
          PieSeries<InventoryData, String>(
            dataSource: inventoryData,
            xValueMapper: (InventoryData inventory, _) => inventory.productName,
            yValueMapper: (InventoryData inventory, _) => (totalQuantity > 0) ? (inventory.quantity / totalQuantity) * 100 : 0,
            dataLabelMapper: (InventoryData inventory, _) => '${inventory.productName}: ${((inventory.quantity / totalQuantity) * 100).toStringAsFixed(1)}%',
            enableTooltip: true,
          ),
        ],
      ),
    );
  }
}

class InventoryData {
  final String productName;
  final int quantity;

  InventoryData(this.productName, this.quantity);
}
