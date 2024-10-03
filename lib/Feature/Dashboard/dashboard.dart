import 'package:flutter/material.dart';
import 'package:ums/homepage.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the chart library

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2F), // Darker theme color
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
            const Text('Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Active Contracts', '5', const Color(0xFF4CAF50)), // Green
                _buildStatCard('Completed Contracts', '10', const Color(0xFF2196F3)), // Blue
                _buildStatCard('Total Purchase', '₹40,000', const Color(0xFFFF9800)), // Orange
                _buildStatCard('Total Sales', '₹90,000', const Color(0xFFF44336)), // Red
              ],
            ),
            const SizedBox(height: 20),
            const Text('Sales and Inventory Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 10),

            // Row containing both Line Graph and Pie Chart
            Row(
              children: [
                // Line Graph for Sales
                Expanded(
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C3E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: LineChart(
                      LineChartData(
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 1),
                              const FlSpot(1, 1.5),
                              const FlSpot(2, 1.4),
                              const FlSpot(3, 3.4),
                              const FlSpot(4, 2.2),
                              const FlSpot(5, 2.8),
                              const FlSpot(6, 2.6),
                            ],
                            isCurved: true,
                            color: Colors.orangeAccent,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Space between the graphs

                // Pie Chart for Inventory
                Expanded(
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C3E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 30,
                            color: Colors.blue,
                            title: '30%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 25,
                            color: Colors.red,
                            title: '25%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 20,
                            color: Colors.green,
                            title: '20%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 15,
                            color: Colors.orange,
                            title: '15%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 10,
                            color: Colors.purple,
                            title: '10%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text('Ongoing Projects', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                elevation: 4,
                color: const Color(0xFF2C2C3E), // Dark background for the list
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildProjectTile('ABC site', 'Mahalaxmi Road'),
                    _buildProjectTile('XYZ site', 'M.G marg'),
                    _buildProjectTile('PQR site', 'College Road'),
                    _buildProjectTile('LMN site', 'Grant Road'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      color: const Color(0xFF1E1E2F), // Dark card background
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.2), // Slightly lighter card color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTile(String title, String subtitle) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        tileColor: const Color(0xFF3C3C4F), // Darker tile color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
