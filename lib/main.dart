// main.dart

import 'package:flutter/material.dart';
import 'recipe_home_page.dart';

void main() {
  runApp(MyRecipeApp());
}

class MyRecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Secret Book',
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFFFAFAFA),
        scaffoldBackgroundColor: Color(0xFFFAFAFA),
      ),
      home: RecipeHomePage(),
    );
  }
}
