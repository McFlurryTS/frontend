import 'dart:convert';

import 'package:demo/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Recipe> recipes = [];

  Future<void> fetchRecipes() async {
    isLoading = true;
    final url = Uri.parse('http://192.168.1.71:3000/recipes');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        recipes = List<Recipe>.from(
          data['recipes'].map((recipe) => Recipe.fromJSON(recipe)),
        );
      } else {
        print('Error: ${response.statusCode}');
        recipes = [];
      }
    } catch (e) {
      print('Error in request: $e');
      recipes = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
