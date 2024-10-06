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
  List<ContractData> ongoingContracts = []; // Ongoing contracts list
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([fetchInventoryData(), fetchSalesData(), fetchContractsData()]);
  }

  Future<void> fetchInventoryData() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:3000/inventory/analysis'));

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
      final response = await http.get(Uri.parse('http://localhost:3000/sales/analysis'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          salesData = jsonResponse
              .map((data) => SalesData(data['productName'], data['totalQuantitySold']))
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

  Future<void> fetchContractsData() async {
    // Simulate a fetch for ongoing contracts
    setState(() {
      ongoingContracts = [
        ContractData('Website Development', 'In Progress', '31st Oct'),
        ContractData('Mobile App Redesign', 'In Progress', '15th Nov'),
        ContractData('Cloud Infrastructure Setup', 'In Progress', '28th Nov'),
      ];
    });
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
        child: Column(
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
                _buildStatCard('Active Contracts', '5'),
                const SizedBox(width: 10,),
                _buildStatCard('Completed Contracts', '10'),
                const SizedBox(width: 10,),
                _buildStatCard('Total Purchase', '₹40,000'),
                const SizedBox(width: 10,),
                _buildStatCard('Total Sales', '₹90,000'),
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
                      color: Colors.white, // Minimalist color
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12, // Soft shadow for depth
                          blurRadius: 10,
                        )
                      ],
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildInventoryPieChart(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Ongoing Contracts',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
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
                child: ListView.builder(
                  itemCount: ongoingContracts.length,
                  itemBuilder: (context, index) {
                    return _buildContractCard(ongoingContracts[index]);
                  },
                ),
              ),
            ),
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
              color: Colors.black12, // Minimal shadow
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
    // Define a list of colors for each segment
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
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CircularSeries>[
        PieSeries<InventoryData, String>(
          dataSource: inventoryData,
          xValueMapper: (InventoryData data, _) => data.name,
          yValueMapper: (InventoryData data, _) => data.quantity,
          dataLabelMapper: (InventoryData data, _) =>
          '${data.name}: ${data.quantity}',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.outer,
            showZeroValue: false,
            color: Colors.black,
          ),
          enableTooltip: true,
          pointColorMapper: (InventoryData data, index) {
            // Assign colors based on the index of the data
            return colors[index % colors.length]; // Cycle through the colors
          },
          explode: true, // Enable explode animation
          explodeIndex: 0, // Explode the first item
          animationDuration: 1200, // Duration of the pie chart animation
        )
      ],
    );
  }




  Widget _buildContractCard(ContractData contract) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(contract.projectName, style: const TextStyle(color: Colors.black)),
        subtitle: Text('Status: ${contract.status}\nDue: ${contract.dueDate}'),
        tileColor: Colors.grey[100],
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

// Class for ongoing contracts
class ContractData {
  final String projectName;
  final String status;
  final String dueDate;

  ContractData(this.projectName, this.status, this.dueDate);
}
