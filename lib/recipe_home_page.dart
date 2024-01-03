import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'add_recipe.dart';
import 'recipe_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeHomePage extends StatefulWidget {
  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> filteredRecipes = [];
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchRecipes();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> fetchRecipes() async {
    final String serverUrl = 'http://127.0.0.1/recipes/get_recipes.php';

    try {
      final response = await http.get(Uri.parse(serverUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          setState(() {
            recipes = jsonResponse.cast<Map<String, dynamic>>();
            filteredRecipes = recipes;
          });
        } else {
          print('Invalid JSON format. Expected a List, but received: $jsonResponse');
        }
      } else {
        print('Failed to load recipes. HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void filterRecipes(String query) {
    setState(() {
      filteredRecipes = recipes
          .where((recipe) => recipe['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Secret Book'),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => filterRecipes(query),
              decoration: InputDecoration(
                hintText: 'Search for recipes...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(
                  recipe: filteredRecipes[index],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFFAFAFA),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                color: Colors.black,
                size: 30.0,
              ),
              SizedBox(width: 8.0),
              isLoggedIn
                  ? ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddRecipeScreen(),
                    ),
                  ).then((value) {
                    if (value != null && value) {
                      fetchRecipes(); // Refresh recipes after adding a new one
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8.0),
                    Text('Add Recipe'),
                  ],
                ),
              )
                  : TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ).then((value) {
                    setState(() {
                      isLoggedIn = value ?? false;
                    });
                  });
                },
                style: TextButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeCard({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // Navigate to details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsPage(
                recipe: recipe,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: recipe['image'],
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['title'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      recipe['description'] ?? '',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Category: ${recipe['category'] ?? ''}',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
