import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:food_delivery_ui/models/order.dart';

Widget orderCard(Order order) {
  final bool isPlaced = order.status == "Placed";
  final Color statusColor = isPlaced ? Colors.green : Colors.red;
  final shortId = order.id.substring(order.id.length - 5);

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
            color: Colors.black
        )
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("ORDER ID: #ORD-$shortId",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(order.status,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text("Date: ${DateFormat('MMM dd, yyyy, hh:mm a').format(order.createdAt)}",
          style: const TextStyle(fontSize: 15),
        ),
        SizedBox(height: 5,),
        Text("ITEMS: ${order.items.map((e) => e.name).join(", ")}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5,),
        Text("TOTAL: ₹${order.total.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange,)
        ),
      ],
    ),
  );
}