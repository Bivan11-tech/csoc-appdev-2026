class MenuItem {

  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String image;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory MenuItem.fromJson(Map<String,dynamic> json) {
    return MenuItem(
      id: json["id"].toString(),
      restaurantId: json["restaurantId"].toString(),
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: (json["price"] as num).toDouble(),
      image: json["image"] ?? "",
    );
  }
}