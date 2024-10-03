import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ums/homepage.dart';

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
        backgroundColor: Color(0xFF1E1E2F), // Darker theme color
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: Text('Dashboard', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Active Contracts', '5', Color(0xFF4CAF50)), // Green
                _buildStatCard('Completed Contracts', '10', Color(0xFF2196F3)), // Blue
                _buildStatCard('Total Purchase', '₹40,000', Color(0xFFFF9800)), // Orange
                _buildStatCard('Total Sales', '₹90,000', Color(0xFFF44336)), // Red
              ],
            ),
            SizedBox(height: 20),
            Text('Ongoing Projects', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Expanded(
              child: Card(
                elevation: 4,
                color: Color(0xFF2C2C3E), // Dark background for the list
                child: ListView(
                  padding: EdgeInsets.all(16.0),
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
      color: Color(0xFF1E1E2F), // Dark card background
      child: Container(
        padding: EdgeInsets.all(16),
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.2), // Slightly lighter card color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTile(String title, String subtitle) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
        tileColor: Color(0xFF3C3C4F), // Darker tile color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
