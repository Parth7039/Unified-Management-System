import 'package:flutter/material.dart';
import 'package:ums/Feature/Contracts/contracts.dart';
import 'package:ums/Feature/Invoice/add_invoice.dart';
import 'package:ums/Feature/Inventory/Screens/product_category.dart';

import 'Feature/Dashboard/dashboard.dart';
import 'Feature/Sales/sales.dart';
import 'Screens/InventoryPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDrawerOpen = true;
  double drawerWidth = 250; // Initial drawer width when open
  Widget selectedPage = const DashboardPage(); // Default page when app starts

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
        backgroundColor: Colors.grey.shade900,
        elevation: 4,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(isDrawerOpen ? Icons.close : Icons.menu, color: Colors.white),
          onPressed: _toggleDrawer,
        ),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.greenAccent),
              onPressed: () {
                // Handle the + action
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // Handle notifications action
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.white),
            onPressed: () {
              // Handle calendar action
            },
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://media.licdn.com/dms/image/D5603AQHbXUt-RZ_BMw/profile-displayphoto-shrink_400_400/0/1699965188678?e=1729123200&v=beta&t=sjmPmTRnKsvmD2C8Fbp1XJj4aZFlsL64H7rA1T0cngU'), // Replace with your image URL
            radius: 15,
          ),
          const SizedBox(width: 10),
          const Text("Gaurav Desale", style: TextStyle(color: Colors.white)),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: drawerWidth,
            decoration: const BoxDecoration(
              color: Color(0xFF344675), // Drawer background color
              borderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20), // Spacer for visual appeal
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildDrawerItem(Icons.dashboard, 'Dashboard', const DashboardPage()),
                      _buildDrawerItem(Icons.inventory, 'Inventory', const InventoryPage()),
                      _buildDrawerItem(Icons.add_task_rounded, 'Contracts', const ContractsPage()),
                      _buildDrawerItem(Icons.settings, 'Settings', const Inventory_Grid()),
                      _buildDrawerItem(Icons.receipt_long, 'Billing', const AddinvoicePage()),
                      _buildDrawerItem(Icons.point_of_sale_sharp, 'Sales', const Salespreviewpage()),
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

  Widget _buildDrawerItem(IconData icon, String title, Widget page) {
    return InkWell(
      onTap: () {
        _navigateTo(page); // Handle tap event and navigate
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedPage.runtimeType == page.runtimeType ? Colors.grey.shade700 : Colors.transparent, // Highlight selected item
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: isDrawerOpen ? Text(title, style: const TextStyle(color: Colors.white)) : null, // Conditionally render title
        ),
      ),
    );
  }
}
