import 'package:flutter/material.dart';
import 'package:ums/homepage.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // For charts
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding JSON

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<InventoryData> inventoryData = [];
  List<SalesData> salesData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([fetchInventoryData(), fetchSalesData()]);
  }

  Future<void> fetchInventoryData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.12.63:3000/inventory/analysis'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          inventoryData = jsonResponse
              .map((data) => InventoryData(data['name'], data['quantity']))
              .toList();
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

  Future<void> fetchSalesData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.12.63:3000/sales/analysis'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse.toString());
        setState(() {
          salesData = jsonResponse
              .map((data) =>
                  SalesData(data['productName'], data['totalQuantitySold']))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load sales data');
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
        backgroundColor: const Color(0xFF1E1E2F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overview',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                    'Active Contracts', '5', const Color(0xFF4CAF50)), // Green
                _buildStatCard('Completed Contracts', '10',
                    const Color(0xFF2196F3)), // Blue
                _buildStatCard('Total Purchase', '₹40,000',
                    const Color(0xFFFF9800)), // Orange
                _buildStatCard(
                    'Total Sales', '₹90,000', const Color(0xFFF44336)), // Red
              ],
            ),
            const SizedBox(height: 20),
            const Text('Sales and Inventory Overview',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 400,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 224, 224, 230),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildSalesChart(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 400,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 224, 224, 230),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildInventoryPieChart(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // const Text('Ongoing Projects',
            //     style: TextStyle(
            //         fontSize: 24,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.black)),
            // const SizedBox(height: 10),
            // // Expanded(
            //   child: Card(
            //     elevation: 4,
            //     color: const Color(0xFF2C2C3E),
            //     child: ListView(
            //       padding: const EdgeInsets.all(16.0),
            //       children: [
            //         _buildProjectCard('Project 1'),
            //         _buildProjectCard('Project 2'),
            //         _buildProjectCard('Project 3'),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Sales Overview'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<SalesData, String>>[
        LineSeries<SalesData, String>(
          dataSource: salesData, // Use salesData instead of data
          xValueMapper: (SalesData sales, _) =>
              sales.month, // Changed to 'month'
          yValueMapper: (SalesData sales, _) =>
              sales.sales, // Changed to 'sales'
          name: 'Sales',
          markerSettings: MarkerSettings(isVisible: true),
        )
      ],
    );
  }

  Widget _buildInventoryPieChart() {
    return SfCircularChart(
      series: <CircularSeries>[
        PieSeries<InventoryData, String>(
          dataSource: inventoryData,
          xValueMapper: (InventoryData data, _) => data.name,
          yValueMapper: (InventoryData data, _) => data.quantity,
          dataLabelMapper: (InventoryData data, _) => data.name,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
    );
  }

  Widget _buildProjectCard(String projectName) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(projectName, style: const TextStyle(color: Colors.white)),
        tileColor: const Color(0xFF4CAF50),
      ),
    );
  }
}

class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
}

class InventoryData {
  final String name;
  final int quantity;

  InventoryData(this.name, this.quantity);
}
