class Product {
  String? id;
  String name;
  String description;
  double price;
  int quantity;
  String categoryId; // This will refer to the category ObjectId in MongoDB.

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      categoryId: json['category'],
    );
  }

  // Method to convert a Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': categoryId,
    };
  }
}
