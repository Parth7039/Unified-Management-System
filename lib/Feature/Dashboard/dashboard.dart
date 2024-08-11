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
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        },),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    height: 120,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width: 1),
                      borderRadius: BorderRadius.circular(13)
                    ),
                    child: Column(
                      children: [
                        Text('Active Contracts',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('5',style: TextStyle(fontSize: 35),)
                      ],
                    ),
                  )
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    height: 120,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width: 1),
                      borderRadius: BorderRadius.circular(13)
                    ),
                    child: Column(
                      children: [
                        Text('Inactive Contracts',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('5',style: TextStyle(fontSize: 35),)
                      ],
                    ),
                  )
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    height: 120,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width: 1),
                      borderRadius: BorderRadius.circular(13)
                    ),
                    child: Column(
                      children: [
                        Text('Completed Contracts',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('7',style: TextStyle(fontSize: 35),)
                      ],
                    ),
                  )
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    height: 120,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width: 1),
                      borderRadius: BorderRadius.circular(13)
                    ),
                    child: Column(
                      children: [
                        Text('Total Contracts',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('15',style: TextStyle(fontSize: 35),)
                      ],
                    ),
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
