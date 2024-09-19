import 'package:flutter/material.dart';

class ContractDetailsPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color statusColor;

  const ContractDetailsPage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.statusColor,
  }) : super(key: key);

  @override
  State<ContractDetailsPage> createState() => _ContractDetailsPageState();
}

class _ContractDetailsPageState extends State<ContractDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: TextStyle(color: Colors.black),),
        backgroundColor: widget.statusColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),

        ],
      )
    );
  }
}
