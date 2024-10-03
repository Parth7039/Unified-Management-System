import 'package:flutter/material.dart';
import 'package:ums/Feature/Invoice/add_invoice.dart';
import 'package:ums/Feature/Invoice/print_invoice.dart';

class BuyerdetailsPage extends StatefulWidget {
  final List<Map<String, String>> addedItems;

  const BuyerdetailsPage({super.key, required this.addedItems});

  @override
  State<BuyerdetailsPage> createState() => _BuyerdetailsPageState();
}

class _BuyerdetailsPageState extends State<BuyerdetailsPage> {
  final TextEditingController consigneeController = TextEditingController();
  final TextEditingController consigneeAddController = TextEditingController();
  final TextEditingController consigneeGSTController = TextEditingController();
  final TextEditingController consigneeStateController = TextEditingController();

  final TextEditingController buyerController = TextEditingController();
  final TextEditingController buyerAddController = TextEditingController();
  final TextEditingController buyerGSTController = TextEditingController();
  final TextEditingController buyerStateController = TextEditingController();

  final TextEditingController invoiceController = TextEditingController();
  final TextEditingController datedController = TextEditingController();
  final TextEditingController dispatchedController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    consigneeController.dispose();
    consigneeAddController.dispose();
    consigneeGSTController.dispose();
    consigneeStateController.dispose();
    buyerController.dispose();
    buyerAddController.dispose();
    buyerGSTController.dispose();
    buyerStateController.dispose();
    invoiceController.dispose();
    datedController.dispose();
    dispatchedController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SizedBox(
        height: 50,
        width: 300,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PrintInvoicePage(
                  consigneeName: consigneeController.text,
                  consigneeAddress: consigneeAddController.text,
                  consigneeGst: consigneeGSTController.text,
                  consigneeState: consigneeStateController.text,
                  buyerName: buyerController.text,
                  buyerAddress: buyerAddController.text,
                  buyerGst: buyerGSTController.text,
                  buyerState: buyerStateController.text,
                  invoiceNo: invoiceController.text,
                  date: datedController.text,
                  dispatchedThrough: dispatchedController.text,
                  destination: destinationController.text,
                  addedItems: widget.addedItems,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'Generate Invoice',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddinvoicePage()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          'Buyer Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Row(
        children: [
          Expanded(
            child: customContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  customTextField(
                    label: 'Consignee (Ship to)',
                    hintText: 'Enter consignee Name',
                    controller: consigneeController,
                  ),
                  customTextField(
                    label: "",
                    hintText: 'Enter Consignee address',
                    controller: consigneeAddController,
                  ),
                  customTextField(
                    label: "",
                    hintText: 'GSTIN/UIN',
                    controller: consigneeGSTController,
                  ),
                  customTextField(
                    label: "",
                    hintText: 'State of supply',
                    controller: consigneeStateController,
                  ),
                  const SizedBox(height: 30),
                  customTextField(
                    label: 'Buyer (Bill to)',
                    hintText: 'Buyer name',
                    controller: buyerController,
                  ),
                  customTextField(
                    label: "",
                    hintText: 'Enter Buyer address',
                    controller: buyerAddController,
                  ),
                  customTextField(
                    label: "",
                    hintText: 'GSTIN/UIN',
                    controller: buyerGSTController,
                  ),
                  customTextField(
                    label: "",
                    hintText: 'Enter Buyer state',
                    controller: buyerStateController,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: customContainer(
              Column(
                children: [
                  const SizedBox(height: 20),
                  customTextField(
                    label: 'Invoice No.',
                    hintText: '',
                    controller: invoiceController,
                  ),
                  customTextField(
                    label: 'Dated',
                    hintText: '',
                    controller: datedController,
                  ),
                  customTextField(
                    label: 'Dispatched through.',
                    hintText: '',
                    controller: dispatchedController,
                  ),
                  customTextField(
                    label: 'Destination',
                    hintText: '',
                    controller: destinationController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom container widget for consistent styling
  Widget customContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  // Custom TextField widget with named parameters
  Widget customTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
