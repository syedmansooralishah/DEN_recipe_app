import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final DatabaseService _databaseService = DatabaseService();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favorites = await _databaseService.getFavorites();
    setState(() {
      isFavorite = favorites.any((fav) => fav.id == widget.recipe.id);
    });
  }

  Future<void> _toggleFavorite() async {
    if (isFavorite) {
      await _databaseService.deleteRecipe(widget.recipe.id);
    } else {
      await _databaseService.insertRecipe(widget.recipe);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6F61), Color(0xFFFFB74D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, size: 28),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Set a solid color for the body
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                    child: Image.network(
                      widget.recipe.imageUrl,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.recipe.title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2F4F4F)),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.recipe.description,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _toggleFavorite,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                label: Text(isFavorite ? "Remove from Favorites" : "Add to Favorites"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF6F61), // Use backgroundColor instead of primary
                  foregroundColor: Colors.white, // Replace onPrimary with foregroundColor
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
