import 'package:flutter/material.dart';
import 'package:food_delivery_ui/services/restaurant_service.dart';
import 'package:food_delivery_ui/widgets/category_card.dart';
import 'package:food_delivery_ui/widgets/restaurant_card.dart';
import 'package:food_delivery_ui/data/category_data.dart';
import 'package:food_delivery_ui/models/restaurant.dart';
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

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
          ),
        ),

        home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchQuery = "";
  String selectedCategory = "All";
  final TextEditingController searchController = TextEditingController();
  String sortBy = "None";

  late Future<List<Restaurant>> restaurantsFuture;

  @override
  void initState() {
    super.initState();
    restaurantsFuture = RestaurantService().getRestaurants();
  }

  Future<void> refreshRestaurants() async {
    setState(() {
      restaurantsFuture = RestaurantService().getRestaurants();
    });
    await restaurantsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderBar(),
            Divider(height: 1, thickness: 1),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshRestaurants,
                color: Colors.orange,
                child: ListView(
                  children: [
                    SizedBox(height: 10),
                    SearchBarWidget(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;});
                      },
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Explore Categories', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CategoryBar(onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Popular near you', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        value: sortBy,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(value: "None", child: Text("Sort"),),
                          DropdownMenuItem(value: "Rating", child: Text("Rating"),),
                          DropdownMenuItem(value: "Delivery Time", child: Text("Delivery Time"),),
                        ],
                        onChanged: (value) {
                          setState(() {
                            sortBy = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    RestaurantList(
                      searchQuery: searchQuery,
                      selectedCategory: selectedCategory,
                      sortBy: sortBy,
                      restaurantsFuture: restaurantsFuture,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeaderBar extends StatelessWidget{
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/boy.jpg',),
        backgroundColor: Colors.orange,
      ),

      title: Text('FoodieHUB', style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      ),

      trailing: IconButton(onPressed: () {},
        icon: Icon(Icons.notifications_none_outlined),
        color: Colors.orange,
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget{
  const SearchBarWidget({super.key, required this.onChanged, required this.controller});
  final TextEditingController controller;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(
                    color: Colors.black
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(
                    color: Colors.grey
                )
            ),
            prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: (){},),
            hintText: "Search for food, restaurants, cuisines..."
        ),
      ),
    );
  }
}

class CategoryBar extends StatefulWidget{
  const CategoryBar({super.key, required this.onCategorySelected});
  final Function(String) onCategorySelected;

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onCategorySelected(
                      categories[index].name,
                    );
                  },
                  child: CategoryWidget(
                    category: categories[index],
                    isSelected: selectedIndex == index,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: 5)
      ],
    );
  }
}

class RestaurantList extends StatelessWidget{
  const RestaurantList({super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.sortBy, required this.restaurantsFuture
  });
  final String searchQuery;
  final String selectedCategory;
  final String sortBy;
  final Future<List<Restaurant>> restaurantsFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Restaurant>>(
      future: restaurantsFuture,
      builder: (context, snapshot) {

        // print("State: ${snapshot.connectionState}");
        // print("Error: ${snapshot.error}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return RestaurantShimmer();
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.red),);
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No restaurants found"));
        }

        final restaurants = snapshot.data!;
        final filteredRestaurants = restaurants.where((restaurant) {
          final query = searchQuery.toLowerCase();
          final matchesSearch =
              restaurant.name.toLowerCase().contains(query) || restaurant.category.toLowerCase().contains(query);
          final matchesCategory =
              selectedCategory=="All" || restaurant.category.toLowerCase()==selectedCategory.toLowerCase();

          return matchesSearch && matchesCategory;
        }).toList();

        if(sortBy=="Rating") {
          filteredRestaurants.sort((a,b) => b.rating.compareTo(a.rating));
        }
        if(sortBy=="Delivery Time") {
          filteredRestaurants.sort((a,b) => a.deliveryTime.compareTo(b.deliveryTime));
        }

        if (filteredRestaurants.isEmpty) {
          return NoSearchResult();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredRestaurants.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: RestaurantCard(
                restaurant: filteredRestaurants[index],
              ),
            );
          },
        );
      },
    );
  }
}

class NoSearchResult extends StatelessWidget {
  const NoSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("No restaurants found", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),),
        ],
      ),
    );
  }
}