import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primaryColor: Color(0xFF6FA3EF),
        scaffoldBackgroundColor: Color(0xFFF9F9F9),
      ),
      home: HomeScreen(),
    );
  }
}
