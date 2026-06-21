import 'package:food_delivery_ui/isar_models/menu_cache.dart';
import 'package:food_delivery_ui/services/isar_service.dart';
import 'package:isar_community/isar.dart';

import '../models/menu_item.dart';
import 'api_service.dart';

class MenuService {
  final ApiService api = ApiService();
  Future<List<MenuItem>> getMenu(String restaurantId) async {
    try {
      final data = await api.get("/api/restaurants/$restaurantId/menu",);
      final menu = data.map<MenuItem>((json) => MenuItem.fromJson(json)).toList();

      await cacheMenuItems(restaurantId, menu);
      return menu;
    }
    catch (e) {
      return await getCachedMenuItems(restaurantId);
    }
  }

  Future<void> cacheMenuItems(String restaurantId, List<MenuItem> menu) async{
    await IsarService.isar.writeTxn(() async {
      final oldItems = await IsarService.isar.menuItemCaches.filter().restaurantIdEqualTo(restaurantId).findAll();
      await IsarService.isar.menuItemCaches.deleteAll(
        oldItems.map((e) => e.isarId).toList(),
      );
      await IsarService.isar.menuItemCaches.putAll(
        menu.map((item) => item.toCache(restaurantId)).toList(),
      );
    });
  }

  Future<List<MenuItem>> getCachedMenuItems(String restaurantId) async {
    final cachedItems = await IsarService.isar.menuItemCaches.filter().restaurantIdEqualTo(restaurantId).findAll();
    return cachedItems.map((cache) => cache.toMenuItem()).toList();
  }
}