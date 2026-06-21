import 'package:isar_community/isar.dart';
import 'package:food_delivery_ui/models/menu_item.dart';

part 'menu_cache.g.dart';

@collection
class MenuItemCache {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late String restaurantId;

  late String name;
  late String description;
  late double price;
  late String image;
}

extension MenuItemCacheMapper on MenuItemCache {
  MenuItem toMenuItem() {
    return MenuItem(
      id: id,
      restaurantId: restaurantId,
      name: name,
      description: description,
      price: price,
      image: image,
    );
  }
}

extension MenuItemMapper on MenuItem {
  MenuItemCache toCache(String restaurantId) {
    return MenuItemCache()
      ..id = id
      ..restaurantId = restaurantId
      ..name = name
      ..description = description
      ..price = price
      ..image = image;
  }
}