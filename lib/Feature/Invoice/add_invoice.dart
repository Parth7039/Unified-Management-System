import 'package:flutter/material.dart';
import 'package:ums/Feature/Invoice/buyer_details.dart';
import 'package:ums/homepage.dart';

class AddinvoicePage extends StatefulWidget {
  const AddinvoicePage({super.key});

  @override
  State<AddinvoicePage> createState() => _AddinvoicePageState();
}

class _AddinvoicePageState extends State<AddinvoicePage> {
  // Controllers for text fields
  final TextEditingController descController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController hsnController = TextEditingController();
  final TextEditingController perController = TextEditingController();

  List<Map<String, String>> addedItems = [];

  void addItem() {
    setState(() {
      addedItems.add({
        'description': descController.text,
        'quantity': quantityController.text,
        'rate': rateController.text,
        'hsn': hsnController.text,
        'per': perController.text,
      });

      // Clear text fields after adding
      descController.clear();
      quantityController.clear();
      rateController.clear();
      hsnController.clear();
      perController.clear();
    });
  }

  void deleteItem(int index) {
    setState(() {
      addedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          'Add Invoice',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () {
          // Navigate to BuyerdetailsPage and pass addedItems
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BuyerdetailsPage(addedItems: addedItems), // Pass addedItems
            ),
          );
        },
        label: const Text(
          'Next',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Row(
        children: [
          // Left column: Add Item form
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Item',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    customTextField(
                      label: 'Description',
                      hintText: 'Enter product description',
                      controller: descController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: customTextField(
                            label: 'Quantity',
                            hintText: 'Enter quantity',
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: customTextField(
                            label: 'Rate',
                            hintText: 'Enter rate',
                            controller: rateController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: customTextField(
                            label: 'HSN Code',
                            hintText: 'Enter code',
                            controller: hsnController,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: customTextField(
                            label: 'Per',
                            hintText: 'Enter unit',
                            controller: perController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: customButton(
                        label: 'Add Item',
                        onPressed: addItem,
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildSavedDataSection(),
                  ],
                ),
              ),
            ),
          ),
          // Right column: Preview box
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: customContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: addedItems.length,
                        itemBuilder: (context, index) {
                          final item = addedItems[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(item['description'] ?? 'No Description'),
                              subtitle: Text(
                                'Quantity: ${item['quantity']} | Rate: ${item['rate']} | HSN: ${item['hsn']} | Per: ${item['per']}',
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteItem(index);
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom TextField widget
  Widget customTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom button widget
  Widget customButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Saved Data Section
  Widget buildSavedDataSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: const [
          Text(
            'Saved Data',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          // Further UI for showing saved data can be added here
        ],
      ),
    );
  }

  // Custom container widget for layout consistency
  Widget customContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
