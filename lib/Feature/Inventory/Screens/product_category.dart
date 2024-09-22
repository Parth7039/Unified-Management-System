import 'package:flutter/material.dart';
import 'package:ums/Feature/Inventory/Screens/product.dart';

class Inventory_Grid extends StatefulWidget {
  const Inventory_Grid({super.key});

  @override
  State<Inventory_Grid> createState() => _Inventory_GridState();
}

class _Inventory_GridState extends State<Inventory_Grid> {
  final List<Map<String, String?>> inventory = [
    {
      'name': 'Switch',
      'description': 'Electrical switch used to control devices.',
      'image': 'https://5.imimg.com/data5/ZV/SX/SI/SELLER-9071585/finoswitch-500x500.png',
    },
    {
      'name': 'Router',
      'description': 'Device that forwards data between networks.',
      'image': 'https://5.imimg.com/data5/ZV/SX/SI/SELLER-9071585/finoswitch-500x500.png',
    },
    {
      'name': 'Cable',
      'description': 'Electrical wire for connections.',
      'image': 'https://5.imimg.com/data5/ZV/SX/SI/SELLER-9071585/finoswitch-500x500.png',
    },
    {
      'name': 'Light Bulb',
      'description': 'Device to emit light in a room.',
      'image': 'https://5.imimg.com/data5/ZV/SX/SI/SELLER-9071585/finoswitch-500x500.png',
    },
    {
      'name': 'Sensor',
      'description': 'Device used for detecting changes in the environment.',
      'image': 'https://5.imimg.com/data5/ZV/SX/SI/SELLER-9071585/finoswitch-500x500.png',
    },
  ];

  void _showAddItemDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'Add New Item',
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
                _buildTextField(imageController, 'Image URL'),
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
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    imageController.text.isNotEmpty) {
                  setState(() {
                    inventory.add({
                      'name': nameController.text,
                      'description': descriptionController.text,
                      'image': imageController.text,
                    });
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
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
        title: const Text('Inventory Grid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 2, // Aspect ratio of each grid item
          ),
          itemCount: inventory.length,
          itemBuilder: (context, index) {
            final item = inventory[index];

            return GestureDetector(
              onTap: () {
                // Navigate to the NewInventory screen when the card is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewInventory(),
                  ),
                );
              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Displaying image from the internet with fallback handling
                    Expanded(
                      child: item['image'] != null
                          ? Image.network(
                        item['image']!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error); // Fallback if image fails to load
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      )
                          : const Icon(Icons.image_not_supported), // Fallback if image is null
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      item['name'] ?? 'Unknown', // Fallback for null name
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      item['description'] ?? 'No description available', // Fallback for null description
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
