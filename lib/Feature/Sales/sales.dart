import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Inventory/Models/product_category_model.dart';
import '../Inventory/Models/product_model.dart';
import '../Inventory/Services/product_services.dart';

class Salespreviewpage extends StatefulWidget {
  @override
  _SalespreviewpageState createState() => _SalespreviewpageState();
}

class _SalespreviewpageState extends State<Salespreviewpage> {
  final TextEditingController buyerController = TextEditingController();
  final TextEditingController itemQuantityController = TextEditingController();

  List<ProductCategory> categories = [];
  List<Product> inventory = [];
  ProductService productService = ProductService();
  ProductCategory? selectedCategory;
  Product? selectedItem;

  List<int> soldItems = List.generate(7, (_) => 0); // Stores sold items for each day of the week
  List<int> revenueData = List.generate(12, (_) => 0); // Monthly revenue data
  int selectedMonth = 0; // For the month filter (0 = Current Month)

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  void dispose() {
    buyerController.dispose();
    itemQuantityController.dispose();
    super.dispose();
  }

  // Fetch categories and products based on category selection
  Future<void> fetchCategories() async {
    try {
      List<ProductCategory> fetchedCategories = await productService.getCategories();
      setState(() {
        categories = fetchedCategories;
        if (categories.isNotEmpty) {
          selectedCategory = categories.first;
          fetchProductsByCategory(selectedCategory!.id!);
        }
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  // Fetch products for the selected category
  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      // Call the correct method to fetch products by category
      List<Product> fetchedProducts = (await productService.getCategories()).cast<Product>();
      setState(() {
        inventory = fetchedProducts;
        if (inventory.isNotEmpty) {
          selectedItem = inventory.first;
        }
      });
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  void sellItem() {
    final quantity = int.tryParse(itemQuantityController.text) ?? 0;

    if (selectedItem != null && selectedItem!.quantity >= quantity) {
      setState(() {
        selectedItem!.quantity -= quantity;
        final revenue = (quantity * selectedItem!.price).toInt();
        revenueData[selectedMonth] = (revenueData[selectedMonth] ?? 0) + revenue;
        int dayIndex = (DateTime.now().weekday % 7); // Ensure dayIndex stays between 0 and 6
        soldItems[dayIndex] += quantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Page'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Section
            Text('Buyer Name:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: buyerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Buyer Name',
              ),
            ),
            SizedBox(height: 16),
            // Category Dropdown
            if (categories.isNotEmpty)
              DropdownButton<ProductCategory>(
                value: selectedCategory,
                items: categories.map((ProductCategory category) {
                  return DropdownMenuItem<ProductCategory>(
                    value: category,
                    child: Text(category.categoryName),
                  );
                }).toList(),
                onChanged: (ProductCategory? newCategory) {
                  setState(() {
                    selectedCategory = newCategory!;
                    fetchProductsByCategory(newCategory.id!);
                  });
                },
              ),
            SizedBox(height: 16),
            // Item Dropdown
            if (inventory.isNotEmpty)
              DropdownButton<Product>(
                value: selectedItem,
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
            SizedBox(height: 16),
            Text('Item Quantity:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: itemQuantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Item Quantity',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: sellItem,
              child: Text('Sell'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            ),
            SizedBox(height: 32),

            // Graph Section
            Text('Sold Items (Week)', style: TextStyle(fontSize: 24)),
            SizedBox(
              height: 200,
              child: buildBarChart(),
            ),
            SizedBox(height: 16),

            // Month Filter
            DropdownButton<int>(
              value: selectedMonth,
              items: List.generate(12, (index) => index).map((int month) {
                return DropdownMenuItem<int>(
                  value: month,
                  child: Text('Month ${month + 1}'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedMonth = newValue!;
                });
              },
            ),

            // Revenue Pie Chart
            Text('Total Revenue (Monthly)', style: TextStyle(fontSize: 24)),
            SizedBox(
              height: 200,
              child: buildPieChart(),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Bar chart for sold items
  Widget buildBarChart() {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (double value, TitleMeta meta) {
                const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    daysOfWeek[value.toInt()],
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: soldItems[index].toDouble(),
                color: Colors.blue,
              ),
            ],
          );
        }),
      ),
    );
  }

  // Pie chart for revenue
  Widget buildPieChart() {
    return PieChart(
      PieChartData(
        sections: List.generate(12, (index) {
          return PieChartSectionData(
            value: revenueData[index].toDouble(),
            title: 'M${index + 1}: \$${revenueData[index]}',
            color: Colors.primaries[index % Colors.primaries.length],
          );
        }),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
