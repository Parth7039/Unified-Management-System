class ProductCategory {
  String? id;
  String categoryName;
  String categoryDescription;
  String categoryImageUrl;

  ProductCategory({
    this.id,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImageUrl,
  });

  // Factory method to create a ProductCategory from JSON
  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['_id'],
      categoryName: json['categoryName'],
      categoryDescription: json['categorydesc'],
      categoryImageUrl: json['categoryImageUrl'],
    );
  }


  // Method to convert a ProductCategory object to JSON
  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'categorydesc': categoryDescription,
      'categoryImageUrl': categoryImageUrl,
    };
  }
}
