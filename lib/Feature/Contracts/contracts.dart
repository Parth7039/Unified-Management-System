import 'package:flutter/material.dart';
import '../../homepage.dart';
import 'contractdetails.dart';
import 'models/Contractmodel.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  TextEditingController _startdateController = TextEditingController();
  TextEditingController _enddateController = TextEditingController();

  // Selected filters (if any)
  String? contractType; // "Government" or "Private"
  String? contractStatus; // "Active", "Inactive", "Completed"

  // Sample list of contracts
  List<Contract> contracts = [
    Contract(
      name: 'Sapphire Heights',
      details: 'Complete electrical wiring of wing A & B',
      duration: '2 months',
      additionalTerms: 'None for now',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 180)),
      partyName: 'Party A',
      partyContact: '1234567890',
      contractType: 'Private',
      contractStatus: 'Active',
    ),
    Contract(
      name: 'Contract 2',
      details: 'Details about contract 2',
      duration: '1 year',
      additionalTerms: 'Term 2',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 365)),
      partyName: 'Party B',
      partyContact: '0987654321',
      contractType: 'Government',
      contractStatus: 'Inactive',
    ),
  ];

  List<Contract> filteredContracts = [];

  @override
  void initState() {
    super.initState();
    filteredContracts = List.from(contracts);
  }

  @override
  void dispose() {
    _startdateController.dispose();
    _enddateController.dispose();
    super.dispose();
  }

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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Text(
          'Contracts',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contract Cards
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildContractCard('Active Contracts', _countContracts('Active')),
                  _buildContractCard('Inactive Contracts', _countContracts('Inactive')),
                  _buildContractCard('Completed Contracts', _countContracts('Completed')),
                  _buildContractCard('Total Contracts', contracts.length.toString()),
                ],
              ),
            ),
            SizedBox(height: 15),
            // Search and ListView
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
                    // Search Field
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
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              filteredContracts = List.from(contracts);
                            } else {
                              filteredContracts = contracts.where((contract) =>
                                  contract.name.toLowerCase().contains(value.toLowerCase()) ||
                                  contract.details.toLowerCase().contains(value.toLowerCase()) ||
                                  contract.partyName.toLowerCase().contains(value.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                      ),
                    ),
                    // Contracts List
                    Container(
                      height: 600, // Adjust based on your UI needs
                      child: ListView.builder(
                        itemCount: filteredContracts.length,
                        itemBuilder: (context, index) {
                          return _buildContractListTile(filteredContracts[index]);
                        },
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

  // Helper method to count contracts based on status
  String _countContracts(String status) {
    return contracts.where((contract) => contract.contractStatus == status).length.toString();
  }

  // Helper method to build contract summary cards
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

  // Helper method to build each contract list tile
  Widget _buildContractListTile(Contract contract) {
    Color statusColor;
    switch (contract.contractStatus) {
      case 'Active':
        statusColor = Colors.green;
        break;
      case 'Inactive':
        statusColor = Colors.red;
        break;
      case 'Completed':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.grey.shade700,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          contract.name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'Start: ${_formatDate(contract.startDate)}',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'End: ${_formatDate(contract.endDate)}',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: statusColor),
            SizedBox(height: 2),
            Text(
              contract.contractStatus,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContractDetailsPage(
                title: contract.name,
                subtitle: contract.details,
                statusColor: statusColor,
                duration: contract.duration,
                additional_terms: contract.additionalTerms,
                startdate: contract.startDate,
                enddate: contract.endDate,
                contract_type: contract.contractType,
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method to format dates as YYYY-MM-DD
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Custom Text Field Widget for reuse
  Widget customTextField(
    String labelText,
    String hintText, {
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: isPassword ? Icon(Icons.lock, color: Colors.black) : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    // Toggle password visibility (if needed)
                    controller.text.isEmpty ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // Implement visibility toggle if needed
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.black),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  // Add Contract Dialog with Switch for Contract Type
  // Add Contract Dialog with Switch for Contract Type
  Widget alertDialog() {
    // Controllers for input fields
    TextEditingController nameController = TextEditingController();
    TextEditingController detailsController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    TextEditingController additionalTermsController = TextEditingController();
    TextEditingController partyNameController = TextEditingController();
    TextEditingController partyContactController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();

    String? selectedContractType; // "Government" or "Private"
    String? selectedContractStatus; // "Active", "Inactive", "Completed"
    bool isGovernment = false; // New variable to track contract type

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text('Add New Contract')),
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.9, // Responsive width
              child: Column(
                children: [
                  SizedBox(height: 35,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Contract Type', style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SwitchListTile(
                    title: Text(isGovernment ? "Government" : "Private"),
                    value: isGovernment,
                    onChanged: (bool value) {
                      setState(() {
                        isGovernment = value;
                        selectedContractType =
                        isGovernment ? "Government" : "Private";
                      });
                    },
                    secondary: Icon(
                        isGovernment ? Icons.account_balance : Icons
                            .person),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Left Column
                      Column(
                        children: [
                          customTextField('Contract Name', 'Enter name here..', controller: nameController),
                          SizedBox(height: 20),
                          customTextField('Contract Details', 'Enter details here..', controller: detailsController),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              _selectStartDate(context, controller: startDateController);
                            },
                            child: AbsorbPointer(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4, // Responsive width
                                child: TextField(
                                  controller: startDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Start Date',
                                    prefixIcon: Icon(Icons.calendar_today),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Right Column
                      Column(
                        children: [
                          customTextField('Contract Duration', 'Enter duration here..', controller: durationController),
                          SizedBox(height: 20),
                          customTextField('Additional Terms', 'Enter additional terms here..', controller: additionalTermsController),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              _selectEndDate(context, controller: endDateController);
                            },
                            child: AbsorbPointer(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4, // Responsive width
                                child: TextField(
                                  controller: endDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'End Date',
                                    prefixIcon: Icon(Icons.calendar_today),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(color: Colors.black),
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
                  SizedBox(height: 20),
                  // Party Details
                  isGovernment ? Container() : Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Party Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 15),
                          customTextField('Party Name', 'Enter name here..', controller: partyNameController),
                          SizedBox(width: 30),
                          customTextField('Party Contact', 'Enter contact here..', controller: partyContactController),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Contract Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Column(
                    children: [
                      RadioListTile(
                        value: "Active",
                        groupValue: selectedContractStatus,
                        title: Text("Active"),
                        onChanged: (value) {
                          setState(() {
                            selectedContractStatus = value as String?;
                          });
                        },
                      ),
                      RadioListTile(
                        value: "Inactive",
                        groupValue: selectedContractStatus,
                        title: Text("Inactive"),
                        onChanged: (value) {
                          setState(() {
                            selectedContractStatus = value as String?;
                          });
                        },
                      ),
                      RadioListTile(
                        value: "Completed",
                        groupValue: selectedContractStatus,
                        title: Text("Completed"),
                        onChanged: (value) {
                          setState(() {
                            selectedContractStatus = value as String?;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        // Cancel Button
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // Add Button
        TextButton(
          child: Text('Add'),
          onPressed: () {
            // Retrieve current state of the dialog
            final dialogState = context as Element;
            final StatefulBuilder? builder = dialogState.findAncestorWidgetOfExactType<StatefulBuilder>();

            // Validate input fields
            if (nameController.text.isEmpty ||
                detailsController.text.isEmpty ||
                durationController.text.isEmpty ||
                startDateController.text.isEmpty ||
                endDateController.text.isEmpty ||
                (isGovernment == false && (partyNameController.text.isEmpty || partyContactController.text.isEmpty)) ||
                selectedContractType == null ||
                selectedContractStatus == null) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill all fields')),
              );
              return;
            }

            // Validate dates
            DateTime? startDate = DateTime.tryParse(startDateController.text);
            DateTime? endDate = DateTime.tryParse(endDateController.text);
            if (startDate == null || endDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid dates')),
              );
              return;
            }

            if (endDate.isBefore(startDate)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('End Date must be after Start Date')),
              );
              return;
            }

            // Create a new contract
            Contract newContract = Contract(
              name: nameController.text,
              details: detailsController.text,
              duration: durationController.text,
              additionalTerms: additionalTermsController.text,
              startDate: startDate!,
              endDate: endDate!,
              partyName: isGovernment ? '' : partyNameController.text,
              partyContact: isGovernment ? '' : partyContactController.text,
              contractType: selectedContractType!,
              contractStatus: selectedContractStatus!,
            );

            // Add to contracts list
            setState(() {
              contracts.add(newContract);
              filteredContracts = List.from(contracts); // Reset filtered list
            });

            // Close the dialog
            Navigator.of(context).pop();

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Contract added successfully')),
            );
          },
        ),
      ],
    );
  }

  // Method to select start date
  Future<void> _selectStartDate(BuildContext context, {required TextEditingController controller}) async {
    final DateTime? picked1 = await showDatePicker(
      context: context,
      initialDate: controller.text.isEmpty ? DateTime.now() : DateTime.parse(controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2400),
    );

    if (picked1 != null) {
      setState(() {
        controller.text = _formatDate(picked1);
      });
    }
  }

  // Method to select end date
  Future<void> _selectEndDate(BuildContext context, {required TextEditingController controller}) async {
    DateTime initialDate;
    if (_startdateController.text.isEmpty) {
      initialDate = DateTime.now();
    } else {
      initialDate = DateTime.tryParse(_startdateController.text) ?? DateTime.now();
    }

    final DateTime? picked2 = await showDatePicker(
      context: context,
      initialDate: controller.text.isEmpty ? initialDate.add(Duration(days: 1)) : DateTime.parse(controller.text),
      firstDate: initialDate,
      lastDate: DateTime(2400),
    );

    if (picked2 != null) {
      setState(() {
        controller.text = _formatDate(picked2);
      });
    }
  }

  // Edit Contract Dialog with Switch for Contract Type
  void _showEditDialog(Contract contract) {
    // Controllers initialized with existing contract data
    TextEditingController nameController = TextEditingController(
        text: contract.name);
    TextEditingController detailsController = TextEditingController(
        text: contract.details);
    TextEditingController durationController = TextEditingController(
        text: contract.duration);
    TextEditingController additionalTermsController = TextEditingController(
        text: contract.additionalTerms);
    TextEditingController partyNameController = TextEditingController(
        text: contract.partyName);
    TextEditingController partyContactController = TextEditingController(
        text: contract.partyContact);
    TextEditingController startDateController = TextEditingController(
        text: _formatDate(contract.startDate));
    TextEditingController endDateController = TextEditingController(
        text: _formatDate(contract.endDate));

    String? selectedContractType = contract.contractType;
    String? selectedContractStatus = contract.contractStatus;

  }
}
