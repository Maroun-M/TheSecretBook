import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ingredient {
  String name;
  String quantity;

  Ingredient({required this.name, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity};
  }
}

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  List<Ingredient> ingredientsList = [];
  TextEditingController imageLinkController = TextEditingController();

  bool recipeAddedSuccessfully = false;

  Future<void> addRecipe() async {
    final String serverUrl = 'http://127.0.0.1/recipes/add_recipe.php';

    // Check for empty name or quantity in ingredients
    for (var ingredient in ingredientsList) {
      if (ingredient.name.isEmpty || ingredient.quantity.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in both name and quantity for all ingredients.'),
          ),
        );
        return;
      }
    }

    // Convert ingredients list to JSON
    List<Map<String, dynamic>> ingredientsJsonList =
    ingredientsList.map((ingredient) => ingredient.toJson()).toList();

    // Create a map to represent the data you want to send in the request
    Map<String, dynamic> data = {
      'title': titleController.text,
      'description': descriptionController.text,
      'ingredients': ingredientsJsonList, // Send as a list
      'category': categoryController.text,
      'imageLink': imageLinkController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success']) {
          setState(() {
            recipeAddedSuccessfully = true;
          });
        } else {
          // Handle errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonResponse['message']),
            ),
          );
        }
      }
    } catch (error) {
      // Handle other errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            // Display the ingredients input fields
            for (var i = 0; i < ingredientsList.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        ingredientsList[i].quantity = value;
                      },
                      decoration: InputDecoration(labelText: 'Quantity'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        ingredientsList[i].name = value;
                      },
                      decoration: InputDecoration(labelText: 'Ingredient ${i + 1} Name'),
                    ),
                  ),
                  SizedBox(width: 8.0),
                ],
              ),
            // Button to add more ingredients
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ingredientsList.add(Ingredient(name: '', quantity: ''));
                });
              },
              child: Text('Add Ingredient'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 16.0),
            // TextField for entering image link
            TextField(
              controller: imageLinkController,
              decoration: InputDecoration(labelText: 'Image Link'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                await addRecipe();
                if (recipeAddedSuccessfully) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product Added Successfully'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
