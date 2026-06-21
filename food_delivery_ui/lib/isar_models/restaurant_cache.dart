import 'package:food_delivery_ui/models/restaurant.dart';
import 'package:isar_community/isar.dart';


part 'restaurant_cache.g.dart';

@collection
class RestaurantCache {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String name;
  late String category;
  late String image;
  late int deliveryTime;
  late double rating;
}

extension RestaurantCacheMapper on RestaurantCache {
  Restaurant toRestaurant(){
    return Restaurant(
        id: id,
        name: name,
        image: image,
        rating: rating,
        deliveryTime: deliveryTime,
        category: category
    );
  }
}

extension RestaurantMapper on Restaurant {
  RestaurantCache toCache() {
    return RestaurantCache()
      ..id = id
      ..name = name
      ..deliveryTime = deliveryTime
      ..category = category
      ..image = image
      ..rating = rating;
  }
}