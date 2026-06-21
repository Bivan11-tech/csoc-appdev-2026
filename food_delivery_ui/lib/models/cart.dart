class CartItem {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String image;
  final String description;

  CartItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.description
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItemId: json["menuItemId"],
      name: json["name"],
      price: (json["price"] as num).toDouble(),
      quantity: json["quantity"],
      image: json["image"],
      description: json["description"]
    );
  }
}