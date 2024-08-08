import 'package:flutter/material.dart';
import 'package:ums/drawer/drawer.dart';

import '../Dashboard/dashboard.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permanent Drawer Example"),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Text("This is contracts"),
      ),
    );
  }
}
