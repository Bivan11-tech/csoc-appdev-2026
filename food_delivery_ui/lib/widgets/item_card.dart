import 'package:flutter/material.dart';
import 'package:food_delivery_ui/models/menu_item.dart';
import 'package:food_delivery_ui/services/cart_service.dart';

class ItemCard extends StatelessWidget{
  ItemCard({super.key, required this.menu});
  final MenuItem menu;
  final cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  menu.image,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.fastfood, size: 80);
                  },
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(menu.name,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                    SizedBox(height: 4),
                    Text(menu.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 12,),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹ ${menu.price.toStringAsFixed(0)}",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        InkWell(
                          onTap: ()async {
                            await cartService.addToCart(menu.id,1,);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Added to cart"),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade200,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                              child: Center(
                                  child: Text("+ Add",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 15),)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}