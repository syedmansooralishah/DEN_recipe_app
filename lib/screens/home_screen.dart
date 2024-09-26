import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';
import 'favorites_screen.dart';  // Import the favorites screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = [];
  List<Recipe> filteredRecipes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/random?apiKey=3d7bb99119944da596a4d00ea0304d0a&number=10'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['recipes'];
        setState(() {
          recipes = jsonData.map((json) => Recipe.fromJson(json)).toList();
          filteredRecipes = recipes; // Initialize filteredRecipes
        });
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching recipes: $error');
    }
  }

  void _filterRecipes(String query) {
    setState(() {
      searchQuery = query;
      filteredRecipes = recipes.where((recipe) {
        return recipe.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _refreshRecipes() async {
    await fetchRecipes(); // Fetch new recipes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFF6F61), // Light Coral
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshRecipes, // Refresh on swipe down
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                onChanged: _filterRecipes,
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey), // Search icon
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            // Recipe grid
            Expanded(
              child: filteredRecipes.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    return _buildRecipeCard(filteredRecipes[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        // Navigate to the recipe detail screen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Round corners
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFB74D), // Light Orange
              Color(0xFFFF6F61), // Light Coral
            ],
            begin: Alignment.topLeft, // Gradient direction
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 8, // How blurry the shadow is
              spreadRadius: 2, // How far the shadow spreads
              offset: Offset(2, 2), // Position of the shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15), // Round corners for child content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image at the top
              Image.network(
                recipe.imageUrl,
                height: 120,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  recipe.title, // Recipe title
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for the title
                  ),
                  maxLines: 1, // Limit title to one line
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  recipe.description, // Recipe description
                  style: TextStyle(color: Colors.white70), // Slightly lighter white
                  maxLines: 2, // Limit description to two lines
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
