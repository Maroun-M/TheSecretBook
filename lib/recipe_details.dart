import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeDetailsPage({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'] ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300.0, // Adjust the height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(recipe['image'] ?? ''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12.0), // Adjust the border radius as needed
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              recipe['title'] ?? '',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Description:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              recipe['description'] ?? '',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Category:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              recipe['category'] ?? '',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (recipe['ingredients'] as List<dynamic>?)
                  ?.map(
                    (ingredient) => Text(
                  '- ${ingredient['name']} - ${ingredient['quantity']}',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
                  .toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}
