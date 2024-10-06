import 'package:flutter/material.dart';
import 'package:ums/Feature/Contracts/Services/contract_services.dart';
import '../../homepage.dart';
import 'contractdetails.dart';
import './Models/contract_model.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  late ContractService _contractService;
  List<Contract> _contracts = [];
  List<Contract> filteredContracts = [];
  bool _isLoading = true;
  final TextEditingController _startdateController = TextEditingController();
  final TextEditingController _enddateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contractService = ContractService();
    // _startdateController.text = _formatDate(widget.contract.effectiveDate);
    // _enddateController.text = _formatDate(widget.contract.endDate);
    _fetchContracts(); // Fetch contracts when the page loads
  }

  @override
  void dispose() {
    _startdateController.dispose();
    _enddateController.dispose();
    super.dispose();
  }

  Future<void> _fetchContracts() async {
    try {
      List<Contract> contracts = await _contractService.fetchContracts();
      setState(() {
        _contracts = contracts;
        filteredContracts = contracts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching contracts: $e');
    }
  }

  Future<void> _addContract(Contract contract) async {
    try {
      await _contractService.addContract(contract);
      _fetchContracts(); // Re-fetch contracts after adding
    } catch (e) {
      print('Error adding contract: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (BuildContext context) {
              return alertDialog();
            },
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.tealAccent),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Text(
          'Contracts',
          style: TextStyle(color: Colors.tealAccent, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
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
                  _buildContractCard(
                      'Active Contracts', _countContracts('Active')),
                  _buildContractCard(
                      'Inactive Contracts', _countContracts('Inactive')),
                  _buildContractCard(
                      'Completed Contracts', _countContracts('Completed')),
                  _buildContractCard(
                      'Total Contracts', _contracts.length.toString()),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Search and ListView
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Column(
                  children: [
                    // Search Field
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        cursorColor: Colors.tealAccent,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade700,
                          hintText: 'Search contracts..',
                          prefixIcon: const Icon(Icons.search,
                              color: Colors.tealAccent),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.tealAccent),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade800),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              filteredContracts = List.from(_contracts);
                            } else {
                              filteredContracts = _contracts.where((contract) {
                                final partyName =
                                    contract.partyDetails?.partyName ??
                                        ''; // Safely handle null values
                                return contract.contractName
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    contract.details
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    partyName
                                        .toLowerCase()
                                        .contains(value.toLowerCase());
                              }).toList();
                            }
                          });
                        },
                      ),
                    ),
                    // Contracts List
                    SizedBox(
                      height: 600, // Adjust based on your UI needs
                      child: ListView.builder(
                        itemCount: _contracts.length,
                        itemBuilder: (context, index) {
                          return _buildContractListTile(_contracts[index]);
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
    return _contracts
        .where((contract) => contract.status == status)
        .length
        .toString();
  }

  // Helper method to build contract summary cards
  Widget _buildContractCard(String title, String count) {
    return Card(
      elevation: 5,
      child: Container(
        height: 120,
        width: 190,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(fontSize: 35, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each contract list tile
  Widget _buildContractListTile(Contract contract) {
    Color statusColor;
    switch (contract.status) {
      case 'Active':
        statusColor = Colors.greenAccent;
        break;
      case 'Inactive':
        statusColor = Colors.redAccent;
        break;
      case 'Completed':
        statusColor = Colors.blueAccent;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.grey.shade800,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          contract.contractName,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Type: ${contract.contractType}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Start: ${_formatDate(contract.effectiveDate)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'End: ${_formatDate(contract.endDate)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Additional Terms: ${contract.additionalTerms ?? 'No additional terms'}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            if (contract.partyDetails != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Party Name: ${contract.partyDetails!.partyName}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    'Party Contact: ${contract.partyDetails!.partyContact}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: statusColor),
            const SizedBox(height: 2),
            Text(
              contract.status,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContractDetailsPage(
                title: contract.contractName,
                subtitle: contract.details,
                statusColor: statusColor,
                duration: contract.duration,
                additional_terms:
                    contract.additionalTerms ?? 'No additional terms',
                startdate: contract.effectiveDate,
                enddate: contract.endDate,
                contract_type: contract.contractType,
                party_name: contract.partyDetails?.partyName ?? 'No party',
                party_contact:
                    contract.partyDetails?.partyContact ?? 'No contact',
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        cursorColor: Colors.tealAccent,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade700,
          hintText: hintText,
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: isPassword
              ? const Icon(Icons.lock, color: Colors.tealAccent)
              : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    // Toggle password visibility (if needed)
                    controller.text.isEmpty
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.tealAccent,
                  ),
                  onPressed: () {
                    // Implement visibility toggle if needed
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.tealAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.tealAccent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red),
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
      title: const Center(child: Text('Add New Contract')),
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width:
                  MediaQuery.of(context).size.width * 0.9, // Responsive width
              child: Column(
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Contract Type',
                        style: TextStyle(
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
                        isGovernment ? Icons.account_balance : Icons.person),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Left Column
                      Column(
                        children: [
                          customTextField('Contract Name', 'Enter name here..',
                              controller: nameController),
                          const SizedBox(height: 20),
                          customTextField(
                              'Contract Details', 'Enter details here..',
                              controller: detailsController),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              _selectStartDate(context,
                                  controller: startDateController);
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.4, // Responsive width
                                child: TextField(
                                  controller: startDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Start Date',
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                          const BorderSide(color: Colors.black),
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
                          customTextField(
                              'Contract Duration', 'Enter duration here..',
                              controller: durationController),
                          const SizedBox(height: 20),
                          customTextField('Additional Terms',
                              'Enter additional terms here..',
                              controller: additionalTermsController),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              _selectEndDate(context,
                                  controller: endDateController);
                            },
                            child: AbsorbPointer(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.4, // Responsive width
                                child: TextField(
                                  controller: endDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'End Date',
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                          const BorderSide(color: Colors.black),
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
                  const SizedBox(height: 20),
                  // Party Details
                  if (!isGovernment)
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Party Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            customTextField('Party Name', 'Enter name here..',
                                controller: partyNameController),
                            customTextField(
                                'Party Contact', 'Enter contact here..',
                                controller: partyContactController),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Contract Status',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Column(
                    children: [
                      RadioListTile(
                        value: "Active",
                        groupValue: selectedContractStatus,
                        title: const Text("Active"),
                        onChanged: (value) {
                          setState(() {
                            selectedContractStatus = value as String;
                          });
                        },
                      ),
                      RadioListTile(
                        value: "Inactive",
                        groupValue: selectedContractStatus,
                        title: const Text("Inactive"),
                        onChanged: (value) {
                          setState(() {
                            selectedContractStatus = value as String;
                          });
                        },
                      ),
                      RadioListTile(
                        value: "Completed",
                        groupValue: selectedContractStatus,
                        title: const Text("Completed"),
                        onChanged: (value) {
                          setState(() {
                            selectedContractStatus = value as String;
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
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // Add Button
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            // Retrieve current state of the dialog
            final dialogState = context as Element;
            final StatefulBuilder? builder =
                dialogState.findAncestorWidgetOfExactType<StatefulBuilder>();

            // Validate input fields
            if (nameController.text.isEmpty ||
                detailsController.text.isEmpty ||
                durationController.text.isEmpty ||
                startDateController.text.isEmpty ||
                endDateController.text.isEmpty ||
                (isGovernment == false &&
                    (partyNameController.text.isEmpty ||
                        partyContactController.text.isEmpty)) ||
                selectedContractType == null ||
                selectedContractStatus == null) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields')),
              );
              return;
            }

            // Validate dates
            DateTime? startDate = DateTime.tryParse(startDateController.text);
            DateTime? endDate = DateTime.tryParse(endDateController.text);
            if (startDate == null || endDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid dates')),
              );
              return;
            }

            if (endDate.isBefore(startDate)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('End Date must be after Start Date')),
              );
              return;
            }

            // Create a new contract
            Contract newContract = Contract(
              contractName: nameController.text,
              details: detailsController.text,
              duration: durationController.text,
              additionalTerms: additionalTermsController.text,
              effectiveDate: startDate,
              endDate: endDate,
              partyDetails: isGovernment
                  ? null // If it's a government contract, no party details
                  : Party(
                      partyName: partyNameController.text,
                      partyContact: partyContactController.text,
                    ),
              contractType: selectedContractType!,
              status: selectedContractStatus!,
            );

             _addContract(newContract);
            // Add to contracts list
            setState(() {
              _contracts.add(newContract);
              filteredContracts = List.from(_contracts); // Reset filtered list
            });

            // Close the dialog
            Navigator.of(context).pop();

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Contract added successfully')),
            );
          },
        ),
      ],
    );
  }

  // Method to select start date
  Future<void> _selectStartDate(BuildContext context,
      {required TextEditingController controller}) async {
    final DateTime? picked1 = await showDatePicker(
      context: context,
      initialDate: controller.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(controller.text),
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
  Future<void> _selectEndDate(BuildContext context,
      {required TextEditingController controller}) async {
    DateTime initialDate;
    if (_startdateController.text.isEmpty) {
      initialDate = DateTime.now();
    } else {
      initialDate =
          DateTime.tryParse(_startdateController.text) ?? DateTime.now();
    }

    final DateTime? picked2 = await showDatePicker(
      context: context,
      initialDate: controller.text.isEmpty
          ? initialDate.add(const Duration(days: 1))
          : DateTime.parse(controller.text),
      firstDate: initialDate,
      lastDate: DateTime(2400),
    );

    if (picked2 != null) {
      setState(() {
        controller.text = _formatDate(picked2);
      });
    }
  }
}
