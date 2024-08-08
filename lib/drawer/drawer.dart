import 'package:flutter/material.dart';
import 'package:ums/Contracts/contracts.dart';
import 'package:ums/Dashboard/dashboard.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF4577D0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Icon(Icons.person_pin_outlined,size: 90,),
          SizedBox(height: 100,),
          ListTile(
            leading: Icon(Icons.home,color: Colors.white,),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
          SizedBox(height: 15,),
          ListTile(
            leading: Icon(Icons.home,color: Colors.white),
            title: Text('Suppliers'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
          SizedBox(height: 15,),
          ListTile(
            leading: Icon(Icons.home,color: Colors.white),
            title: Text('Billing'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
          SizedBox(height: 15,),
          ListTile(
            leading: Icon(Icons.settings,color: Colors.white),
            title: Text('Contracts'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ContractsPage()),
              );
            },
          ),
          SizedBox(height: 15,),
          ListTile(
            leading: Icon(Icons.home,color: Colors.white),
            title: Text('Purchases'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
          SizedBox(height: 15,),
          ListTile(
            leading: Icon(Icons.home,color: Colors.white),
            title: Text('Inventory'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}