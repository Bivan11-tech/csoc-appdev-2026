import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../isar_models/menu_cache.dart';
import '../isar_models/order_cache.dart';
import '../isar_models/restaurant_cache.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [
        RestaurantCacheSchema,
        MenuItemCacheSchema,
        OrderCacheSchema,
      ],
      directory: dir.path,
    );
  }
}