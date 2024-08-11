import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Color(0xFF8697C4),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // CustomContainer(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 120,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 2
                            )
                          ),
                        ),
                        Container(
                          height: 120,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 2
                              )
                          ),
                        ),
                        Container(
                          height: 120,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 2
                              )
                          ),
                        ),
                        Container(
                          height: 120,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.black,
                                  width: 2
                              )
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 400,
                          width: 270,
                          decoration: BoxDecoration(
                            color: Color(0xFF5B5B5B),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Text('Your Checklist',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)
                            ],
                          ),
                        ),
                        Container(
                          height: 400,
                          width: 1000,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1,color: Colors.black)
                          ),
                          child: Center(
                            child: Text('This is a graph'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Container(
                          width: 300,
                          height: 400,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2,color: Colors.black),
                            borderRadius: BorderRadius.circular(10)
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
