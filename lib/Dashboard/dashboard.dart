import 'package:flutter/material.dart';
import 'package:ums/drawer/drawer.dart';

import '../Contracts/contracts.dart';

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
        title: Text("Permanent Drawer Example"),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Text("This is dashboard"),
      ),
    );
  }
}
