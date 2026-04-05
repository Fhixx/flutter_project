class Product {
  final int id;
  final String name;
  final String size;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.size,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["nama"],
      price: json["harga"],
      size: json["satuan"],
    );
  }

  String get label => "$name $size";
}
