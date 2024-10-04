import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define a model class for SalesData
class SalesData {
  final String productName;
  final int totalQuantitySold;

  SalesData(this.productName, this.totalQuantitySold);
}

// Function to fetch sales data from the API
Future<List<SalesData>> fetchSalesData() async {
  final response =
      await http.get(Uri.parse('http://192.168.12.63:3000/sales/analysis'));

  if (response.statusCode == 200) {
    // Parse the JSON response
    final List<dynamic> jsonResponse = json.decode(response.body);

    // Convert JSON data to List<SalesData>
    return jsonResponse
        .map(
            (data) => SalesData(data['productName'], data['totalQuantitySold']))
        .toList();
  } else {
    throw Exception('Failed to load sales data');
  }
}

class SalesOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Overview'),
      ),
      body: FutureBuilder<List<SalesData>>(
        future: fetchSalesData(), // Call the API to fetch data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Show a loading indicator
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('Error: ${snapshot.error}')); // Show an error message
          } else if (snapshot.hasData) {
            return SalesChart(
                snapshot.data!); // Pass the fetched data to SalesChart
          } else {
            return Center(
                child: Text('No data available')); // Handle no data case
          }
        },
      ),
    );
  }
}

class SalesChart extends StatelessWidget {
  final List<SalesData> data;

  SalesChart(this.data);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Sales Overview'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<SalesData, String>>[
        LineSeries<SalesData, String>(
          dataSource: data,
          xValueMapper: (SalesData sales, _) => sales.productName,
          yValueMapper: (SalesData sales, _) => sales.totalQuantitySold,
          name: 'Sales',
          markerSettings: MarkerSettings(isVisible: true),
        )
      ],
    );
  }
}
