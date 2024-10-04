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
        backgroundColor: const Color(0xFFEDE7F6), // Light Purple for the app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF7E57C2)), // Darker Purple for contrast
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        title: const Text('Dashboard', style: TextStyle(color: Color(0xFF7E57C2))), // Darker Purple text
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF7E57C2))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Active Contracts', '5', const Color(0xFFD1C4E9)), // Light Purple
                _buildStatCard('Completed Contracts', '10', const Color(0xFFB39DDB)), // Soft Purple
                _buildStatCard('Total Purchase', '₹40,000', const Color(0xFF9575CD)), // Medium Purple
                _buildStatCard('Total Sales', '₹90,000', const Color(0xFF7E57C2)), // Darker Purple
              ],
            ),
            const SizedBox(height: 20),
            const Text('Sales and Inventory Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF7E57C2))),
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
                      color: const Color(0xFFEDE7F6), // Light Purple background
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
                            color: Colors.deepPurple,
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
                      color: const Color(0xFFEDE7F6), // Light Purple background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 30,
                            color: const Color(0xFF9575CD), // Medium Purple
                            title: '30%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 25,
                            color: const Color(0xFF7E57C2), // Dark Purple
                            title: '25%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 20,
                            color: const Color(0xFFB39DDB), // Soft Purple
                            title: '20%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 15,
                            color: const Color(0xFFD1C4E9), // Light Purple
                            title: '15%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: 10,
                            color: const Color(0xFFEDE7F6), // Very Light Purple
                            title: '10%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 16, color: Colors.deepPurple),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text('Ongoing Projects', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF7E57C2))),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                elevation: 4,
                color: const Color(0xFFEDE7F6), // Light Purple background for the list
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
      color: const Color(0xFFEDE7F6), // Light Purple background for stat cards
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.2), // Lighter tone of the color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
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
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        subtitle: Text(subtitle, style:  TextStyle(color: Colors.deepPurple.shade200)),
        tileColor: const Color(0xFFD1C4E9), // Light Purple for tiles
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
