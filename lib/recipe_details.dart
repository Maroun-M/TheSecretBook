import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final List<String> ingredients;

  RecipeDetailsPage({
    required this.title,
    required this.description,
    required this.image,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              description,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ingredients
                  .map((ingredient) => Text('- $ingredient'))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
