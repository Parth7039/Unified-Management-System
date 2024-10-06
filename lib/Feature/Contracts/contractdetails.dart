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
  final String party_name;
  final String party_contact;

  const ContractDetailsPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statusColor,
    required this.duration,
    required this.additional_terms,
    required this.startdate,
    required this.enddate,
    required this.contract_type,
    required this.party_name,
    required this.party_contact,
  });

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
    title = widget.title;
    subtitle = widget.subtitle;
    duration = widget.duration;
    additionalTerms = widget.additional_terms;
  }

  Future<void> _editDetails() async {
    String newTitle = title;
    String newSubtitle = subtitle;
    String newDuration = duration;
    String newAdditionalTerms = additionalTerms;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Contract Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: newTitle,
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: (value) {
                    newTitle = value;
                  },
                ),
                TextFormField(
                  initialValue: newSubtitle,
                  decoration: const InputDecoration(labelText: 'Subtitle'),
                  onChanged: (value) {
                    newSubtitle = value;
                  },
                ),
                TextFormField(
                  initialValue: newDuration,
                  decoration: const InputDecoration(labelText: 'Duration'),
                  onChanged: (value) {
                    newDuration = value;
                  },
                ),
                TextFormField(
                  initialValue: newAdditionalTerms,
                  decoration:
                      const InputDecoration(labelText: 'Additional Terms'),
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  title = newTitle;
                  subtitle = newSubtitle;
                  duration = newDuration;
                  additionalTerms = newAdditionalTerms;
                });
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: const Text('Save'),
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
        backgroundColor: Colors.tealAccent,
        onPressed: _editDetails, // Open the edit dialog when button is pressed
        child: const Icon(Icons.edit, color: Colors.black),
      ),
      appBar: AppBar(
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: widget.statusColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contract Details Card
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 5)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${DateFormat('dd/MM/yy').format(widget.startdate)} - ${DateFormat('dd/MM/yy').format(widget.enddate)}',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    additionalTerms,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Status Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contract Type:',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.contract_type,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Material List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const ListTile(
                      title: Text(
                        'Materials',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      trailing: Text(
                        'Quantity',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildMaterialTile('10 mm earthing wire', '3'),
                          _buildMaterialTile('Fan Plugs', '15'),
                          _buildMaterialTile('Switch board with plates', '5'),
                          // Add more materials here if needed
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Delete Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // Implement delete functionality here
                },
                child: const Text('Delete Contract',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each material list tile
  Widget _buildMaterialTile(String materialName, String quantity) {
    return ListTile(
      title: Text(materialName, style: const TextStyle(color: Colors.white)),
      trailing: Text(quantity, style: const TextStyle(color: Colors.white)),
      tileColor: Colors.grey.shade600,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
