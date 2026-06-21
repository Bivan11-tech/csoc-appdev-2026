import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  Category({
    required this.name,
    required this.icon,
  });
}

final categories = [
  Category(name: "All", icon: Icons.grid_view_rounded,),
  Category(name: "Fast Food", icon: Icons.fastfood_rounded,),
  Category(name: "Healthy", icon: Icons.eco_rounded),
  Category(name: "Indian", icon: Icons.rice_bowl_rounded),
  Category(name: "Dessert",icon: Icons.icecream_rounded),
  Category(name: "Beverages", icon: Icons.local_drink_rounded,),
  Category(name: "Cakes", icon: Icons.cake_rounded),
  Category(name: "See More", icon: Icons.more_horiz_rounded)
];
