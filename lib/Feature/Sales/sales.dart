import 'package:flutter/material.dart';
import 'package:ums/Feature/Sales/sales_services.dart';
import '../Inventory/Models/product_model.dart';
import '../Inventory/Services/product_services.dart';

class Salespreviewpage extends StatefulWidget {
  const Salespreviewpage({super.key});

  @override
  _SalespreviewpageState createState() => _SalespreviewpageState();
}

class _SalespreviewpageState extends State<Salespreviewpage> {
  final TextEditingController buyerController = TextEditingController();
  final TextEditingController itemQuantityController = TextEditingController();

  List<Product> inventory = [];
  ProductService productService = ProductService();
  SaleService saleService = SaleService();
  Product? selectedItem;

  @override
  void initState() {
    super.initState();
    // Fetch all products when the page initializes
    fetchProducts();
  }

  @override
  void dispose() {
    buyerController.dispose();
    itemQuantityController.dispose();
    super.dispose();
  }

  // Fetch all products from the API
  Future<void> fetchProducts() async {
    try {
      inventory = await productService
          .getAllProducts(); // Assuming you have a method to get all products
      setState(() {});
    } catch (e) {
      // Handle any exceptions here
      print('Error fetching products: $e');
    }
  }

  Future<void> handleSale() async {
    final String buyerName = buyerController.text;
    final String productId = selectedItem?.id ?? '';
    final int quantitySold = int.tryParse(itemQuantityController.text) ?? 0;

    try {
      await saleService.createSale(
          buyerName, productId, quantitySold, null); // No date provided
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale recorded successfully!')),
      );
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Page'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Section
            const Text('Buyer Name:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: buyerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Buyer Name',
              ),
            ),
            const SizedBox(height: 16),
            // Item Dropdown
            if (inventory.isNotEmpty)
              DropdownButton<Product>(
                value: selectedItem,
                hint: const Text('Select an item'),
                items: inventory.map((Product item) {
                  return DropdownMenuItem<Product>(
                    value: item,
                    child: Text('${item.name} (Available: ${item.quantity})'),
                  );
                }).toList(),
                onChanged: (Product? newItem) {
                  setState(() {
                    selectedItem = newItem!;
                  });
                },
              ),
            const SizedBox(height: 16),
            const Text('Item Quantity:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: itemQuantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Item Quantity',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                handleSale();
                print("Buyer${buyerController.text}");
                buyerController.clear();
                itemQuantityController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text('Record Sales'),
            ),
            const SizedBox(height: 32),

            // Graph Section
          ],
        ),
      ),
    );
  }
}
