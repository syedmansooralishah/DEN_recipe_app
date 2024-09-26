class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final String description;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'].toString(),
      title: json['title'],
      imageUrl: json['image'],
      description: json['summary'], // Adjust based on your API response
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
