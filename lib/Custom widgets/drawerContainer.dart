import 'package:flutter/material.dart';
import 'package:ums/Contracts/contracts.dart';
import 'package:ums/Dashboard/dashboard.dart';

class CustomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Color(0xFF3D52A0),
          borderRadius: BorderRadius.circular(11)
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Icon(Icons.person_pin_outlined,size: 90,),
            SizedBox(height: 100,),
            ListTile(
              leading: Icon(Icons.home,color: Colors.white,),
              title: Text('Dashboard',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            SizedBox(height: 15,),
            ListTile(
              leading: Icon(Icons.home,color: Colors.white),
              title: Text('Suppliers',style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            SizedBox(height: 15,),
            ListTile(
              leading: Icon(Icons.home,color: Colors.white),
              title: Text('Billing',style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            SizedBox(height: 15,),
            ListTile(
              leading: Icon(Icons.settings,color: Colors.white),
              title: Text('Contracts',style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ContractsPage()),
                );
              },
            ),
            SizedBox(height: 15,),
            ListTile(
              leading: Icon(Icons.home,color: Colors.white),
              title: Text('Purchases',style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            SizedBox(height: 15,),
            ListTile(
              leading: Icon(Icons.home,color: Colors.white),
              title: Text('Inventory',style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}