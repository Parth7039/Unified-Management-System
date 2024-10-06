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

  // Sample static sales data for display
  final List<Map<String, dynamic>> salesHistory = [
    {'buyer': 'John Doe', 'product': 'Product A', 'quantity': 2, 'date': '2024-10-06'},
    {'buyer': 'Jane Smith', 'product': 'Product B', 'quantity': 5, 'date': '2024-10-05'},
    {'buyer': 'Alice Johnson', 'product': 'Product C', 'quantity': 3, 'date': '2024-10-04'},
  ];

  @override
  void initState() {
    super.initState();
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
      inventory = await productService.getAllProducts();
      setState(() {});
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> handleSale() async {
    final String buyerName = buyerController.text;
    final String productId = selectedItem?.id ?? '';
    final int quantitySold = int.tryParse(itemQuantityController.text) ?? 0;

    try {
      await saleService.createSale(buyerName, productId, quantitySold, null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale recorded successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buyer Name Input
              const Text(
                'Buyer Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: buyerController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter buyer name',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Dropdown
              const Text(
                'Select Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              if (inventory.isNotEmpty)
                DropdownButton<Product>(
                  value: selectedItem,
                  hint: const Text('Choose an item'),
                  isExpanded: true,
                  items: inventory.map((Product item) {
                    return DropdownMenuItem<Product>(
                      value: item,
                      child: Text('${item.name} (Available: ${item.quantity})'),
                    );
                  }).toList(),
                  onChanged: (Product? newItem) {
                    setState(() {
                      selectedItem = newItem;
                    });
                  },
                ),
              const SizedBox(height: 20),

              // Quantity Input
              const Text(
                'Item Quantity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: itemQuantityController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter quantity',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    handleSale();
                    buyerController.clear();
                    itemQuantityController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Record Sale',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sales History Section
              const Text(
                'Sales History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              // Display sales history
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: salesHistory.length,
                itemBuilder: (context, index) {
                  final sale = salesHistory[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      title: Text('${sale['buyer']} - ${sale['product']}'),
                      subtitle: Text('Quantity: ${sale['quantity']}, Date: ${sale['date']}'),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            // Graph Section
          ],            
          ),

        ),
      ),
    );
  }
}
