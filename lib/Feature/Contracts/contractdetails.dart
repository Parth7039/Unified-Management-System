import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractDetailsPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color statusColor;
  final String duration;
  final String additional_terms;
  final DateTime startdate;
  final DateTime enddate;
  final String contract_type;

  const ContractDetailsPage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.statusColor,
    required this.duration,
    required this.additional_terms,
    required this.startdate,
    required this.enddate,
    required this.contract_type,
  }) : super(key: key);

  @override
  State<ContractDetailsPage> createState() => _ContractDetailsPageState();
}

class _ContractDetailsPageState extends State<ContractDetailsPage> {
  late String title;
  late String subtitle;
  late String duration;
  late String additionalTerms;

  @override
  void initState() {
    super.initState();
    // Initialize variables with widget data
    title = widget.title;
    subtitle = widget.subtitle;
    duration = widget.duration;
    additionalTerms = widget.additional_terms;
  }

  // Function to display the edit dialog
  Future<void> _editDetails() async {
    String newTitle = title;
    String newSubtitle = subtitle;
    String newDuration = duration;
    String newAdditionalTerms = additionalTerms;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Contract Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: newTitle,
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (value) {
                    newTitle = value;
                  },
                ),
                TextFormField(
                  initialValue: newSubtitle,
                  decoration: InputDecoration(labelText: 'Subtitle'),
                  onChanged: (value) {
                    newSubtitle = value;
                  },
                ),
                TextFormField(
                  initialValue: newDuration,
                  decoration: InputDecoration(labelText: 'Duration'),
                  onChanged: (value) {
                    newDuration = value;
                  },
                ),
                TextFormField(
                  initialValue: newAdditionalTerms,
                  decoration: InputDecoration(labelText: 'Additional Terms'),
                  onChanged: (value) {
                    newAdditionalTerms = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Update the details with the new values
                  title = newTitle;
                  subtitle = newSubtitle;
                  duration = newDuration;
                  additionalTerms = newAdditionalTerms;
                });
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _editDetails, // Open the edit dialog when button is pressed
        child: Icon(Icons.edit, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: widget.statusColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 1100),
                      Text(
                          '${DateFormat('dd/MM/yy').format(widget.startdate)} - ${DateFormat('dd/MM/yy').format(widget.enddate)}'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Text(
                      additionalTerms,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Text(
                      duration,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Materials',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    trailing: Text(
                      'Quantity',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  ListTile(
                    title: Text('10 mm earthing wire'),
                    trailing: Text('3'),
                  ),
                  ListTile(
                    title: Text('Fan Plugs'),
                    trailing: Text('15'),
                  ),
                  ListTile(
                    title: Text('Switch board with plates'),
                    trailing: Text('5'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
