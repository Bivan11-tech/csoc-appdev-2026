import 'package:isar_community/isar.dart';

import '../models/restaurant.dart';
import 'api_service.dart';
import '../isar_models/restaurant_cache.dart';
import 'isar_service.dart';

class RestaurantService {
  final ApiService api = ApiService();
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final data = await api.get("/api/restaurants");
      final restaurant = data.map<Restaurant>((json) => Restaurant.fromJson(json)).toList();

      await cacheRestaurants(restaurant);

      return restaurant;
    }
    catch (e) {
      return await getCachedRestaurants();
    }
  }

  Future<void> cacheRestaurants(List<Restaurant> restaurants,) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.restaurantCaches.clear();
      await IsarService.isar.restaurantCaches.putAll(
        restaurants.map((restaurant) => restaurant.toCache()).toList(),
      );
    });
  }

  Future<List<Restaurant>> getCachedRestaurants() async {
    final cachedRestaurants = await IsarService.isar.restaurantCaches.where().findAll();
    return cachedRestaurants.map((cache) => cache.toRestaurant()).toList();
  }
}