import 'package:flutter/material.dart';
import 'package:ums/Feature/Invoice/buyer_details.dart';

class AddinvoicePage extends StatefulWidget {
  const AddinvoicePage({super.key});

  @override
  State<AddinvoicePage> createState() => _AddinvoicePageState();
}

class _AddinvoicePageState extends State<AddinvoicePage> {
  // Controllers for text fields
  TextEditingController descController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController hsnController = TextEditingController();
  TextEditingController perController = TextEditingController();

  // List to store added items
  List<Map<String, String>> addedItems = [];

  // Function to add item to the list
  void addItem() {
    setState(() {
      addedItems.add({
        'description': descController.text,
        'quantity': quantityController.text,
        'rate': rateController.text,
        'hsn': hsnController.text,
        'per': perController.text,
      });

      // Clear the text fields after adding the item
      descController.clear();
      quantityController.clear();
      rateController.clear();
      hsnController.clear();
      perController.clear();
    });
  }

  void deleteitem(int index){
    setState(() {
      addedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Text('Next',style: TextStyle(color: Colors.white),),
          onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuyerdetailsPage()));
          },
      ),
      body: Row(
        children: [
          // Left column: Add Item form
          Expanded(
            child: customContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Add Item',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customTextField(
                      'Description',
                      'Enter product description',
                      controller: descController,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: customTextField(
                          'Quantity',
                          'Enter quantity',
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: customTextField(
                          'Rate',
                          'Enter rate',
                          controller: rateController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: customTextField(
                          'HSN Code',
                          'Enter code',
                          controller: hsnController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: customTextField(
                          'Per',
                          'Enter unit',
                          controller: perController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: addItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          'Add Item',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right column: Preview box
          Expanded(
            child: customContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Preview',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: addedItems.length,
                      itemBuilder: (context, index) {
                        final item = addedItems[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text(item['description']!),
                              subtitle: Text(
                                'Quantity: ${item['quantity']} | Rate: ${item['rate']} | HSN: ${item['hsn']} | Per: ${item['per']}',
                              ),
                              trailing: IconButton(onPressed: (){deleteitem(index);}, icon: Icon(Icons.delete)),
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
        ],
      ),
    );
  }

  // Custom TextField widget
  Widget customTextField(
      String label,
      String hintText, {
        required TextEditingController controller,
        bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.18, // 40% of screen width
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Custom container widget for layout consistency
  Widget customContainer(Widget defChild) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(15),
        ),
        child: defChild,
      ),
    );
  }
}
