import 'package:flutter/material.dart';
import 'package:food_delivery_ui/browsescreen.dart';
import 'package:food_delivery_ui/homepage.dart';
import 'package:food_delivery_ui/orderscreen.dart';
import 'package:food_delivery_ui/profilescreen.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int myIndex=0;
  final List<Widget> screens = [
    MyHomePage(),
    //BrowseScreen(),
    OrderScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[myIndex],
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.orange,
          currentIndex: myIndex,
          onTap: (index){
            setState(() {
              myIndex=index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded),label: "Home"),
            //BottomNavigationBarItem(icon: Icon(Icons.search_rounded),label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded),label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded),label: "Profile"),
          ]
      ),
    );
  }
}