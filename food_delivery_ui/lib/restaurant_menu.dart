import 'package:flutter/material.dart';
import 'package:food_delivery_ui/cartscreen.dart';
import 'package:food_delivery_ui/widgets/item_card.dart';
import 'package:food_delivery_ui/widgets/shimmer_effect.dart';
import 'models/restaurant.dart';
import 'package:food_delivery_ui/services/menu_service.dart';
import 'package:food_delivery_ui/models/menu_item.dart';

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: Colors.orange,
//           ),
//         ),
//
//         home: RestaurantMenu()
//     );
//   }
// }

class RestaurantMenu extends StatelessWidget{
  const RestaurantMenu({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FoodieHUB', style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.orange,),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_rounded, color: Colors.orange,),
          ),
        ],
      ),
      body: SafeArea(
          child: Stack(
            children: [
              ListView(
                children: [
                  RestaurantHeader(restaurant: restaurant),
                  SizedBox(height: 5,),
                  CatTabs(),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 3,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text("Recommended Items",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  MenuList(restaurant: restaurant),
                ],
              ),
              Basket(restaurant: restaurant),
            ],
          )
      ),
    );
  }
}


class RestaurantHeader extends StatelessWidget{
  const RestaurantHeader({super.key, required this.restaurant});
  final Restaurant restaurant;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: Hero(
            tag: restaurant.name,
            child: Image.network(
              restaurant.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 15,
          right: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(restaurant.name, style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6,),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star,color: Colors.white, size: 14,),
                        SizedBox(width: 4),
                        Text("${restaurant.rating} (500+ Ratings)", style: TextStyle(color: Colors.white, fontSize: 14,),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),

                  // Row(
                  //
                  //   children: [
                  //     Icon(Icons.location_on_rounded, color: Colors.white, size: 15,),
                  //     SizedBox(width: 4),
                  //     Text(restaurant.location, style: TextStyle(color: Colors.white, fontSize: 14,),
                  //     ),
                  //   ],
                  // ),
                ],
              ),

              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, color: Colors.white, size: 15,),
                  SizedBox(width: 4),
                  Text("${restaurant.deliveryTime.toString()} mins delivery", style: TextStyle(color: Colors.white, fontSize: 14,),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CatTabs extends StatefulWidget{
  const CatTabs({super.key});

  @override
  State<CatTabs> createState() => _CatTabsState();
}

class _CatTabsState extends State<CatTabs> {
  final cat = ["Recommendation","Burger","Momo","Pizza","Roll","Shwarma","more"];
  int selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cat.length,
          itemBuilder: (context, index) {
            bool isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected?Colors.orange:Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                    child: Center(
                        child: Text(cat[index],
                          style: TextStyle(color: isSelected?Colors.white:Colors.black)
                        )
                    ),
                  ),
                ),
              )
            );
          },
      ),
    );
  }
}

class Basket extends StatelessWidget{
  const Basket({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(
          tag: "cart",
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>CartPage(restaurant: restaurant))
                );
              },
              icon: Icon(Icons.shopping_basket_rounded,color: Colors.white,),
              label: Text("View Basket",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuList extends StatelessWidget{
  const MenuList({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenuItem>>(
      future: MenuService().getMenu(restaurant.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MenuShimmer();
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}",);
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No menu items found"));
        }

        final menuItems = snapshot.data!;

        return Column(
          children: menuItems.map((item) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ItemCard(menu: item),
            );
          }).toList(),
        );
      },
    );
  }

}