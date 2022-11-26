
class Product {
  const Product({
     required this.id,
     required this.name,
     required this.quantity,
     required this.price,
  });

  final int id;
  final String name;
  final int quantity;
  final double price;

  @override
  String toString() =>
      'Product{id: $id, name: $name, quantity: $quantity, price: $price}';

  Map<String, dynamic> toGsheets() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };

  }

  factory Product.fromGsheets(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'] ?? ''),
      name: json['name'],
      quantity: int.parse(json['quantity'] ?? ''),
      price: double.parse(json['price'] ?? ''),
    );
  }

}