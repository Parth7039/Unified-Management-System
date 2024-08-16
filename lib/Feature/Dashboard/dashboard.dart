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
                        Text('Completed Contracts',style: TextStyle(fontWeight: FontWeight.bold),),
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
                        Text('Total Purchase',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('₹40,000',style: TextStyle(fontSize: 35),)
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
                        Text('Total Sales',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('₹90,000',style: TextStyle(fontSize: 35),)
                      ],
                    ),
                  )
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 450,
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13)
                    ),
                    child: ListView(
                      children: [
                        Center(child: Text('Ongoing Projects',style: TextStyle(fontWeight: FontWeight.bold),)),
                        SizedBox(height: 15,),
                        ListTile(
                          tileColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          title: Text('ABC site',style: TextStyle(color: Colors.white),),
                          subtitle: Text('Mahalaxmi Road'),
                        ),
                        SizedBox(height: 15,),
                        ListTile(
                          tileColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          title: Text('XYZ site',style: TextStyle(color: Colors.white),),
                          subtitle: Text('M.G marg'),
                        ),
                        SizedBox(height: 15,),
                        ListTile(
                          tileColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          title: Text('PQR site',style: TextStyle(color: Colors.white),),
                          subtitle: Text('College Road'),
                        ),
                        SizedBox(height: 15,),
                        ListTile(
                          tileColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          title: Text('LMN site',style: TextStyle(color: Colors.white),),
                          subtitle: Text('Grant Road'),
                        ),
                        SizedBox(height: 15,),
                        ListTile(
                          tileColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          title: Text('LMN site',style: TextStyle(color: Colors.white),),
                          subtitle: Text('Grant Road'),
                        ),
                      ],
                    )
                  ),
                ),
                SizedBox(width: 15,),
                Container(
                  height: 450,
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black)
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
