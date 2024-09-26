import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';
import 'recipe_detail_screen.dart'; // Import your RecipeDetailScreen

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Recipe> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favoriteRecipes = await _databaseService.getFavorites();
    setState(() {});
  }

  Future<void> _deleteFavorite(String recipeId) async {
    await _databaseService.deleteRecipe(recipeId);
    _loadFavorites(); // Reload favorites after deletion
  }

  void _navigateToRecipeDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6F61), Color(0xFFFFB74D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: favoriteRecipes.isEmpty
          ? Center(
        child: Text('No favorites yet!', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: favoriteRecipes.length,
          itemBuilder: (context, index) {
            final recipe = favoriteRecipes[index];
            return Dismissible(
              key: Key(recipe.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                _deleteFavorite(recipe.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${recipe.title} deleted')),
                );
              },
              child: GestureDetector(
                onTap: () => _navigateToRecipeDetail(recipe), // Navigate on tap
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            recipe.imageUrl,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded( // Wrap the Text in an Expanded widget
                          child: Text(
                            recipe.title,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteFavorite(recipe.id);
                          },
                        ),
                      ],
                    ),
                  ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
