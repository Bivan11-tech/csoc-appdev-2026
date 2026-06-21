import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(settings);

    await notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showOrderPlaced({
    required String orderId,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'Order status notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    await notifications.show(
      0,
      'Order Confirmed 🎉',
      'Order #ORD-$orderId has been placed successfully.',
      const NotificationDetails(
        android: androidDetails,
      ),
    );
  }
}