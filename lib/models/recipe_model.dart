class Recipe {
  String name;
  String author;
  String image_link;
  List<String> ingredients;
  List<String> recipeSteps;

  Recipe({
    required this.name,
    required this.author,
    required this.image_link,
    required this.ingredients,
    required this.recipeSteps,
  });

  factory Recipe.fromJSON(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      author: json['author'],
      image_link: json['image_link'],
      recipeSteps: List<String>.from(json['recipe']),
      ingredients: List<String>.from(json['ingredients']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'author': author,
      'image_link': image_link,
      'recipe': recipeSteps,
      'ingredients': ingredients,
    };
  }

  @override
  String toString() {
    return 'Recipe{name: $name, author: $author, image_link: $image_link, recipeSteps: $recipeSteps, ingredients: $ingredients}';
  }
}
