import 'package:flutter/material.dart';
import '../../homepage.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {

  TextEditingController _startdateController = TextEditingController();
  TextEditingController _enddateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialog();
            },
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildContractCard('Active Contracts', '5'),
                  _buildContractCard('Inactive Contracts', '5'),
                  _buildContractCard('Completed Contracts', '10'),
                  _buildContractCard('Total Contracts', '19'),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search contracts..',
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 600,
                      child: ListView(
                        children: [
                          _buildContractListTile(
                              'Contract 1', 'Details about contract 1', Colors.red),
                          _buildContractListTile(
                              'Contract 2', 'Details about contract 2', Colors.green),
                          _buildContractListTile(
                              'Contract 3', 'Details about contract 3', Colors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractCard(String title, String count) {
    return Card(
      elevation: 5,
      child: Container(
        height: 120,
        width: 190,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              count,
              style: TextStyle(fontSize: 35),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractListTile(String title, String subtitle, Color color) {
    return ListTile(
      hoverColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      tileColor: Colors.deepOrange,
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white70),
      ),
      trailing: Icon(
        Icons.circle,
        color: color,
      ),
      onTap: () {
        // Handle tile tap
      },
    );
  }

  Widget alertDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text('Add New Contract')),
      content: Container(
        height: 650,
        width: 900,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                customTextField('Contract Name', 'Enter name here..'),
                SizedBox(height: 20),
                customTextField('Contract Details', 'Enter details here..'),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _selectStartDate(context);
                    },
                    child: AbsorbPointer(
                      child: Container(
                        width: 420,
                        child: TextField(
                          controller: _startdateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                            prefixIcon: Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                customTextField('Contract duration', 'Enter duration here..'),
                SizedBox(height: 20),
                customTextField('Additional terms', 'Enter additional terms here..'),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _selectEndDate(context);
                    },
                    child: AbsorbPointer(
                      child: Container(
                        width: 420,
                        child: TextField(
                          controller: _enddateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            prefixIcon: Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            // Add contract logic
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget customTextField(String labelText, String hintText) {
    return Container(
      width: 420,  // Set the fixed width here
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked1 = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2400),
    );

    if (picked1 != null) {
      setState(() {
        _startdateController.text = picked1.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked2 = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2400),
    );

    if (picked2 != null) {
      setState(() {
        _enddateController.text = picked2.toString().split(" ")[0];
      });
    }
  }

}
