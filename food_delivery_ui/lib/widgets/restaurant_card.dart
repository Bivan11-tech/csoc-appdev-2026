import 'package:flutter/material.dart';
import 'package:food_delivery_ui/models/restaurant.dart';
import 'package:food_delivery_ui/restaurant_menu.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>RestaurantMenu(restaurant: restaurant,))
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15),
        color: Theme.of(context).cardColor,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: restaurant.name,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    child: Image.network(
                      restaurant.image,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 18,),
                          SizedBox(width: 5),
                          Text(restaurant.rating.toString(), style: TextStyle(fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.name, style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  SizedBox(height: 6,),
                  Text(restaurant.category, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),),
                  SizedBox(height: 6,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time_rounded,color: Theme.of(context).colorScheme.onSurfaceVariant,),
                      SizedBox(width: 5,),
                      Text("${restaurant.deliveryTime.toString()} mins delivery",
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant,)
                      ),
                      SizedBox(width: 30,),
                      // Icon(Icons.money_rounded,color: Colors.grey,),
                      // SizedBox(width: 5,),
                      // Text(restaurant.priceForTwo,style: TextStyle(color: Colors.grey,),),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}