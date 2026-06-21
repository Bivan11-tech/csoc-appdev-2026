import 'package:food_delivery_ui/models/cart.dart';
import 'package:food_delivery_ui/services/api_service.dart';

class CartService {
  final ApiService api = ApiService();

  Future<List<CartItem>> getCart() async {
    final response = await api.get("/api/cart");

    return (response["items"] as List).map((e) => CartItem.fromJson(e)).toList();
  }

  Future<void> addToCart(String menuItemId, int quantity) async {
    await api.post(
      "/api/cart",
      {
        "menuItemId": menuItemId,
        "quantity": quantity,
      },
    );
  }

  Future<void> updateCartItem(String menuItemId, int quantity) async {
    await api.put(
      "/api/cart/$menuItemId",
      {
        "quantity": quantity,
      },
    );
  }

  Future<void> removeCartItem(String menuItemId,) async {
    await api.delete("/api/cart/$menuItemId",);
  }

  Future<void> clearCart() async {
    await api.delete("/api/cart");
  }
}