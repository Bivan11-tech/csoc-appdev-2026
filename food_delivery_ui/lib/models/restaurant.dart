class Restaurant {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int deliveryTime;
  final String category;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.deliveryTime,
    required this.category,
  });

  factory Restaurant.fromJson(Map<String,dynamic> json){
    return Restaurant(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      rating: json["rating"].toDouble(),
      deliveryTime: json["deliveryTime"],
      category: json["category"],
    );
  }
}