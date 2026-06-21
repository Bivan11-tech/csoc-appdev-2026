import 'package:flutter/material.dart';
import 'package:food_delivery_ui/services/isar_service.dart';
import 'package:food_delivery_ui/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery_ui/welcomepage.dart';
import 'package:food_delivery_ui/mainscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.init();
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _screenToShow = const WelcomeScreen();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }


  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if(token != null && token.isNotEmpty){
      setState(() {
        _screenToShow = const MainScreen();
      });
    }
    else {
      setState(() {
        _screenToShow = const WelcomeScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: _screenToShow,
    );
  }
}