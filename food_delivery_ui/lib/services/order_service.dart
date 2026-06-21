import 'package:food_delivery_ui/isar_models/order_cache.dart';
import 'package:food_delivery_ui/models/cart.dart';
import 'package:food_delivery_ui/models/order.dart';
import 'package:food_delivery_ui/services/api_service.dart';
import 'package:food_delivery_ui/services/isar_service.dart';
import 'package:isar_community/isar.dart';

class OrderService {
  final ApiService api = ApiService();

  Future<Order> createOrder(List<CartItem> cartItems,String promoCode) async {
    final items = cartItems.map((item) => {
      "menuItemId": item.menuItemId,
      "name": item.name,
      "quantity": item.quantity,
      "price": item.price,
    }).toList();

    final data = await api.post("/api/orders",
      {
        "items": items,
        "promoCode": promoCode,
      },
    );

    return Order.fromJson(data);
  }

  Future<List<Order>> getOrders() async {
    try {
      final data = await api.get('/api/orders');
      final orders = data.map<Order>((json) => Order.fromJson(json)).toList();

      await cacheOrders(orders);
      return orders;
    }
    catch (e) {
      return await getCachedOrders();
    }
  }

  // Future<Order> getOrderById(String id) async {
  //   final response = await api.get("/api/orders/$id");
  //   return Order.fromJson(response);
  // }

  Future<void> cacheOrders(List<Order> orders) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.orderCaches.clear();
      await IsarService.isar.orderCaches.putAll(
        orders.map((order) => order.toCache()).toList(),
      );
    });
  }

  Future<List<Order>> getCachedOrders() async {
    final cachedOrders = await IsarService.isar.orderCaches.where().findAll();
    return cachedOrders.map((cache) => cache.toOrder()).toList();
  }
}