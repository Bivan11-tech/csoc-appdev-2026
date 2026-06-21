import 'package:flutter/material.dart';
import 'package:food_delivery_ui/widgets/order_card.dart';
import 'package:food_delivery_ui/models/order.dart';
import 'package:food_delivery_ui/services/order_service.dart';
import 'package:food_delivery_ui/widgets/shimmer_effect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orders UI',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: OrderScreen(),
    );
  }
}


class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  final OrderService orderService = OrderService();
  List<Order> orders = [];
  bool isLoading = true;

  Future<void> loadOrders() async {
    setState(() {
      isLoading = true;
    });
    try{
      final data = await orderService.getOrders();
      setState(() {
        orders = data;
      });
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MY ORDERS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading? OrderShimmer() :
      RefreshIndicator(
        onRefresh: loadOrders,
        color: Colors.orange,
        child: orders.isEmpty ? ListView(
          children: [
            SizedBox(height: 250),
            Center(
              child: Text("No orders placed yet!", style: TextStyle(color: Colors.grey, fontSize: 16,)),
            ),
          ],
        ) : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return orderCard(order);
          },
        ),
      ),
    );
  }
}