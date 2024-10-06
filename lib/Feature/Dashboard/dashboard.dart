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
  int activeContractsCount = 0; // To hold active contracts count
  int completedContractsCount = 0; // To hold completed contracts count
  double totalSalesPrice = 0; // To hold total sales price
  double totalInventoryPrice = 0; // To hold total inventory price
  int totalInventoryCount = 0; // To hold total inventory count
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchDashBoardData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/dashboard'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse['totalInventoryPrice']);
        setState(() {
          activeContractsCount = jsonResponse['active'];
          completedContractsCount = jsonResponse['completed'];
          totalSalesPrice = jsonResponse['totalSalesPrice'];
          totalInventoryPrice = jsonResponse['totalInventoryPrice'];
          totalInventoryCount = jsonResponse['totalCount'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }

    // Call separate functions to fetch inventory and sales data
    
  }

  Future<void> fetchData() async{
    fetchDashBoardData();
    await Future.wait([fetchInventoryData(), fetchSalesData(), fetchContractsData()]);
  }

  Future<void> fetchInventoryData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/inventory/analysis'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          inventoryData = jsonResponse
              .map((data) => InventoryData(data['name'], data['quantity']))
              .toList();
        });
      } else {
        throw Exception('Failed to load inventory data');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  Future<void> fetchSalesData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/sales/analysis'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          salesData = jsonResponse
              .map((data) => SalesData(data['productName'], data['totalQuantitySold']))
              .toList();
        });
      } else {
        throw Exception('Failed to load sales data');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  Future<void> fetchContractsData() async {
    // Simulate a fetch for ongoing contracts
    // setState(() {
    //   ongoingContracts = [
    //     ContractData('Website Development', 'In Progress', '31st Oct'),
    //     ContractData('Mobile App Redesign', 'In Progress', '15th Nov'),
    //     ContractData('Cloud Infrastructure Setup', 'In Progress', '28th Nov'),
    //   ];
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Minimalist design - remove shadows
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Active Contracts', activeContractsCount.toString()),
                      const SizedBox(width: 10,),
                      _buildStatCard('Completed Contracts', completedContractsCount.toString()),
                      const SizedBox(width: 10,),
                      _buildStatCard('Total Purchase', '₹${totalSalesPrice.toString()}'),
                      const SizedBox(width: 10,),
                      _buildStatCard('Total Inventory', '₹${totalInventoryPrice.toString()}'),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sales and Inventory Overview',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 400,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: _buildSalesChart(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 400,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: _buildInventoryPieChart(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                ],
              ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
          dataSource: salesData,
          xValueMapper: (SalesData sales, _) => sales.month,
          yValueMapper: (SalesData sales, _) => sales.sales,
          name: 'Sales',
          markerSettings: const MarkerSettings(isVisible: true),
        )
      ],
    );
  }

  Widget _buildInventoryPieChart() {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
      Colors.teal,
      Colors.indigo,
      Colors.lime,
    ];

    return SfCircularChart(
      title: ChartTitle(text: 'Inventory Overview'),
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<InventoryData, String>(
          dataSource: inventoryData,
          xValueMapper: (InventoryData data, _) => data.name,
          yValueMapper: (InventoryData data, _) => data.quantity,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          pointColorMapper: (InventoryData data, _) => colors[inventoryData.indexOf(data) % colors.length],
        )
      ],
    );
  }

  Widget _buildContractCard(ContractData contract) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(contract.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Status: ${contract.status} - Due: ${contract.dueDate}'),
      ),
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}

class InventoryData {
  final String name;
  final int quantity;

  InventoryData(this.name, this.quantity);
}

class ContractData {
  final String name;
  final String status;
  final String dueDate;

  ContractData(this.name, this.status, this.dueDate);
}
