import 'package:flutter/material.dart';
import 'package:ums/Feature/Inventory/Models/product_category_model.dart';
import 'package:ums/Feature/Inventory/Screens/product.dart';
import 'package:ums/Feature/Inventory/Services/category_services.dart';

class Inventory_Grid extends StatefulWidget {
  const Inventory_Grid({super.key});

  @override
  State<Inventory_Grid> createState() => _Inventory_GridState();
}

class _Inventory_GridState extends State<Inventory_Grid> {
  List<ProductCategory> inventory = [];
  final CategoryService categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  fetchCategories() async {
    inventory = await categoryService.getCategories();
    setState(() {});
  }

  createCategory(String catName, String catDesc, String imageUrl) async {
    await categoryService.createCategory(ProductCategory(
      categoryName: catName,
      categoryDescription: catDesc,
      categoryImageUrl: imageUrl,
    ));
    fetchCategories();
  }

  void _showAddItemDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: const Text('Add New Item'),
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    imageController.text.isNotEmpty) {
                  createCategory(nameController.text,
                      descriptionController.text, imageController.text);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories (${inventory.length})'),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 2,
          ),
          itemCount: inventory.length,
          itemBuilder: (context, index) {
            final item = inventory[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(
                      categoryId: item.id!,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: item.categoryImageUrl != null
                          ? Image.network(
                        item.categoryImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                        loadingBuilder:
                            (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      )
                          : const Icon(Icons.image_not_supported),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      item.categoryName ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      item.categoryDescription ?? 'No description available',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
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
        backgroundColor: Colors.grey[800],
      ),
    );
  }
}
