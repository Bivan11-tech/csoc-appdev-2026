import 'package:flutter/material.dart';

class BrowseScreen extends StatelessWidget{
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.construction_rounded,
              size: 80,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text("Coming Soon", style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            ),
            SizedBox(height: 10),
            Text("This feature is under development.", style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
            ),
          ],
        ),
      ),
    );
  }
}