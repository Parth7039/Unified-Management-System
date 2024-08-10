import 'package:flutter/material.dart';
import 'package:ums/Dashboard/dashboard.dart'; // Assuming you have these pages
import 'package:ums/Screens/InventoryPage.dart';

import 'homepage.dart'; // Create this page as needed

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

