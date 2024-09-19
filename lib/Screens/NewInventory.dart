import 'package:flutter/material.dart';

class NewInventory extends StatefulWidget {
  @override
  _NewInventoryState createState() => _NewInventoryState();
}

class _NewInventoryState extends State<NewInventory> {
  List<Map<String, dynamic>> inventory = [
    {
      'name': 'Item 1',
      'description': 'High-quality product',
      'model': 'Model A',
      'quantity': 10,
    },
    {
      'name': 'Item 2',
      'description': 'Durable and reliable',
      'model': 'Model B',
      'quantity': 5,
    },
    {
      'name': 'Item 3',
      'description': 'Top seller',
      'model': 'Model C',
      'quantity': 15,
    },
  ];

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController =
        TextEditingController(text: inventory[index]['name']);
        TextEditingController descriptionController =
        TextEditingController(text: inventory[index]['description']);
        TextEditingController modelController =
        TextEditingController(text: inventory[index]['model']);
        TextEditingController quantityController = TextEditingController(
            text: inventory[index]['quantity'].toString());

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'Edit Item',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name'),
                _buildTextField(descriptionController, 'Description'),
                _buildTextField(modelController, 'Model'),
                _buildTextField(quantityController, 'Quantity',
                    inputType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  inventory[index] = {
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'model': modelController.text,
                    'quantity': int.tryParse(quantityController.text) ?? 0,
                  };
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addItem() {
    // This function can be implemented to add a new item to the inventory.
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();
        TextEditingController modelController = TextEditingController();
        TextEditingController quantityController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'Add Item',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name'),
                _buildTextField(descriptionController, 'Description'),
                _buildTextField(modelController, 'Model'),
                _buildTextField(quantityController, 'Quantity',
                    inputType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  inventory.add({
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'model': modelController.text,
                    'quantity': int.tryParse(quantityController.text) ?? 0,
                  });
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Grid'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of columns in the grid
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 4 / 2, // Aspect ratio of each grid item
          ),
          itemCount: inventory.length,
          itemBuilder: (context, index) {
            final item = inventory[index];

            return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Description: ${item['description']}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          'Model: ${item['model']}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          'Quantity: ${item['quantity']}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 8.0,
                    top: 8.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () => _editItem(index),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
