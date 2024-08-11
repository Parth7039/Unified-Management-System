import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Feature/Dashboard/dashboard.dart';
import 'Screens/InventoryPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDrawerOpen = true;
  double drawerWidth = 250; // Initial drawer width when open

  void _toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      drawerWidth = isDrawerOpen ? 250 : 70; // Shrink or expand drawer
    });
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isDrawerOpen ? Icons.close : Icons.menu, color: Colors.black),
          onPressed: _toggleDrawer,
        ),
        title: Container(
          width: 200, // Adjust width to your preference
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Handle notifications action
            },
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'), // Replace with your asset path
            radius: 15,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: drawerWidth,
            color: Colors.blue,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
                        _navigateTo(DashboardPage()); // Navigate to Dashboard page
                      }),
                      _buildDrawerItem(Icons.inventory, 'Inventory', () {
                        _navigateTo(InventoryPage()); // Navigate to Inventory page
                      }),
                      _buildDrawerItem(Icons.person, 'Profile', () {
                        // Add navigation for Profile page
                      }),
                      _buildDrawerItem(Icons.settings, 'Settings', () {
                        // Add navigation for Settings page
                      }),
                      _buildDrawerItem(Icons.logout, 'Logout', () {
                        // Handle logout
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InventoryPage(), // Default page when app starts
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: isDrawerOpen ? Text(title, style: TextStyle(color: Colors.white)) : null,
      onTap: onTap, // Handle tap event
    );
  }
}
