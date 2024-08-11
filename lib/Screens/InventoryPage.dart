import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InventoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 2,
        titleSpacing: 0,
        title: Text(
          'Order Statistic',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today_outlined, color: Colors.black),
            onPressed: () {
              // Handle date picker or any other action
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticsRow(),
            SizedBox(height: 20),
            _buildCharts(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatisticCard(
          title: "Today's Sale",
          value: '\$24,763',
          percentageChange: '+12%',
          color: Colors.blueAccent,
        ),
        _buildStatisticCard(
          title: "Today's Orders",
          value: '270',
          percentageChange: '-17.5%',
          color: Colors.cyanAccent,
        ),
        _buildStatisticCard(
          title: "Today's Revenue",
          value: '\$1,235',
          percentageChange: '-3.7%',
          color: Colors.redAccent,
        ),
        _buildStatisticCard(
          title: "Today's Visitors",
          value: '19,465',
          percentageChange: '+10.9%',
          color: Colors.amberAccent,
        ),
      ],
    );
  }

  Widget _buildStatisticCard({
    required String title,
    required String value,
    required String percentageChange,
    required Color color,
  }) {
    return Container(
      width: 350,
      child: Card(
        color: Colors.white, // Match background color
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                percentageChange,
                style: TextStyle(
                  fontSize: 20,
                  color: percentageChange.contains('-') ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharts() {
    return Expanded(
      child: Row(
        children: [
          Expanded(child: _buildBarChart()),
          SizedBox(width: 20),
          Expanded(child: _buildLineChart()),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Overview',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 8,
                          color: Colors.lightBlueAccent,
                          width: 10,
                        ),
                        BarChartRodData(
                          toY: 12,
                          color: Colors.blue,
                          width: 10,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 10,
                          color: Colors.lightBlueAccent,
                          width: 10,
                        ),
                        BarChartRodData(
                          toY: 16,
                          color: Colors.blue,
                          width: 10,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 14,
                          color: Colors.lightBlueAccent,
                          width: 10,
                        ),
                        BarChartRodData(
                          toY: 18,
                          color: Colors.blue,
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Overview',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  minX: 0,
                  maxX: 4,
                  minY: 0,
                  maxY: 6,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 4),
                        FlSpot(2, 3),
                        FlSpot(3, 5),
                        FlSpot(4, 3),
                      ],
                      isCurved: true,
                      color: Colors.orange,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}