import 'package:flutter/material.dart';
import 'package:food_delivery_ui/loginpage.dart';
import 'package:food_delivery_ui/registerpage.dart';
import 'package:food_delivery_ui/widgets/ui_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register UI',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: WelcomeScreen(),
    );
  }
}


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("FoodieHUB", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Image.network(
                  'https://images.unsplash.com/vector-1775025870058-e2786890a077?q=80&w=596&auto=format&fit=crop',
                  height: media.width * 0.6,
                  fit: BoxFit.contain,
                ),
              ),

              Text("Discover the best foods from over 1,000\nrestaurants and fast delivery to your\ndoorstep",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: media.width * 0.1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: RoundButton(
                  title: "Login",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  },
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: RoundButton(
                  title: "Create an Account",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                  },
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}