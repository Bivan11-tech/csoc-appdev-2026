import 'package:isar_community/isar.dart';
import '../models/order.dart';

part 'order_cache.g.dart';

@embedded
class OrderItemCache {
  late String name;
  late int quantity;
  late double price;
}

@collection
class OrderCache {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String status;
  late double total;
  late DateTime createdAt;
  late List<OrderItemCache> items;
}

extension OrderCacheMapper on OrderCache {
  Order toOrder() {
    return Order(
      id: id,
      status: status,
      total: total,
      createdAt: createdAt,
      items: items.map((item) {
        return OrderItem(
          name: item.name,
          quantity: item.quantity,
          price: item.price,
        );
      }).toList(),
    );
  }
}

extension OrderMapper on Order {
  OrderCache toCache() {
    return OrderCache()
      ..id = id
      ..status = status
      ..total = total
      ..createdAt = createdAt
      ..items = items.map((item) {
        return OrderItemCache()
          ..name = item.name
          ..quantity = item.quantity
          ..price = item.price;
      }).toList();
  }
}