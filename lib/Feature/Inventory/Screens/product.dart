import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/product_model.dart';
import '../Services/product_services.dart'; // Assuming the Product model is in this file

class ProductScreen extends StatefulWidget {
  final String categoryId; // Category ID passed from the previous screen

  const ProductScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _productService =
      ProductService(); // Initialize ProductService
  List<Product> _products = []; // List to hold products
  bool _loading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products when the screen is initialized
  }

  // Method to fetch products by category ID
  Future<void> _fetchProducts() async {
    try {
      List<Product> products =
          await _productService.getProductsByCategory(widget.categoryId);
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
      print('Error fetching products: $error');
    }
  }

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController =
            TextEditingController(text: _products[index].name);
        TextEditingController descriptionController =
            TextEditingController(text: _products[index].description);
        TextEditingController priceController =
            TextEditingController(text: _products[index].price.toString());
        TextEditingController quantityController =
            TextEditingController(text: _products[index].quantity.toString());

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
                _buildTextField(priceController, 'Price',
                    inputType: TextInputType.number),
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
              onPressed: () async {
                final updatedProduct = Product(
                  id: _products[index].id,
                  name: nameController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  categoryId: _products[index].categoryId,
                );

                await _updateProduct(
                    updatedProduct); // Update product on the server
                setState(() {
                  _products[index] = updatedProduct;
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

  Future<void> _updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/products/${product.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();
        TextEditingController priceController = TextEditingController();
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
                _buildTextField(priceController, 'Price',
                    inputType: TextInputType.number),
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
              onPressed: () async {
                final newProduct = Product(
                  name: nameController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  categoryId: widget.categoryId, // Use the passed category ID
                );

                await _productService.createProduct(newProduct,
                    widget.categoryId); // Create product on the server
                setState(() {
                  _products.add(newProduct);
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

  // Future<void> _createProduct(Product product) async {
  //   final response = await http.post(
  //     Uri.parse('http://localhost:3000/products'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(product.toJson()),
  //   );

  //   if (response.statusCode != 201) {
  //     throw Exception('Failed to create product');
  //   }
  // }

  Widget _buildTextField(TextEditingController controller, String labelText,
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
        title: Text('Products (${_products.length})'),
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
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final item = _products[index];

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
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Description: ${item.description}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          'Price: \$${item.price}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          'Quantity: ${item.quantity}',
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
