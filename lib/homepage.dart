import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ums/Feature/Contracts/contracts.dart';
import 'package:ums/Screens/NewInventory.dart';
import 'package:ums/Screens/inventory_grid.dart';

import 'Feature/Dashboard/dashboard.dart';
import 'Screens/InventoryPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDrawerOpen = true;
  double drawerWidth = 250; // Initial drawer width when open
  Widget selectedPage = DashboardPage(); // Default page when app starts

  void _toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      drawerWidth = isDrawerOpen ? 250 : 70; // Shrink or expand drawer
    });
  }

  void _navigateTo(Widget page) {
    setState(() {
      selectedPage = page; // Set the selected page and rebuild the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(isDrawerOpen ? Icons.close : Icons.menu, color: Colors.black),
          onPressed: _toggleDrawer,
        ),
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.green),
              onPressed: () {
                // Handle the + action
              },
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
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
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Handle notifications action
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today_outlined, color: Colors.black),
            onPressed: () {
              // Handle calendar action
            },
          ),
          CircleAvatar(
            backgroundImage: NetworkImage('https://media.licdn.com/dms/image/D5603AQHbXUt-RZ_BMw/profile-displayphoto-shrink_400_400/0/1699965188678?e=1729123200&v=beta&t=sjmPmTRnKsvmD2C8Fbp1XJj4aZFlsL64H7rA1T0cngU'), // Replace with your image URL
            radius: 15,
          ),
          SizedBox(width: 10),
          Text("Gaurav Desale"),
          SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: drawerWidth,
            color: Color(0xFF344675), // Matching color from the provided image
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
                      _buildDrawerItem(Icons.add_task_rounded, 'Contracts', () {
                        _navigateTo(ContractsPage()); // Navigate to contracts page
                      }),
                      _buildDrawerItem(Icons.settings, 'Settings', () {
                        _navigateTo(Inventory_Grid()); // Navigate to contracts page
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
              child: selectedPage, // Display the selected page
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
