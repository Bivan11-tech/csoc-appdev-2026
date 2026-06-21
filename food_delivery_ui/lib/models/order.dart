class Order {
  final String id;
  final String status;
  final double total;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      status: json["status"],
      total: (json["total"] as num).toDouble(),
      createdAt: DateTime.parse(json["createdAt"]),
      items: (json["items"] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json["name"],
      quantity: json["quantity"],
      price: (json["price"] as num).toDouble(),
    );
  }
}