import 'package:flutter/material.dart';
class BuyerdetailsPage extends StatefulWidget {
  const BuyerdetailsPage({super.key});

  @override
  State<BuyerdetailsPage> createState() => _BuyerdetailsPageState();
}

class _BuyerdetailsPageState extends State<BuyerdetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50,
          width: 300,
          child: ElevatedButton(onPressed: (){},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text('Generate Invoice',style: TextStyle(color: Colors.white),)))
    );
  }
}
