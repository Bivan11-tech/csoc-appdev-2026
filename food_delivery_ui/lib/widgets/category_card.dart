import 'package:flutter/material.dart';
import 'package:food_delivery_ui/data/category_data.dart';

class CategoryWidget extends StatelessWidget{
  const CategoryWidget({super.key, required this.isSelected, required this.category,});
  final Category category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 2,
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange.shade300 : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(category.icon,size: 30,
              )
          ),
          Text(category.name, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}