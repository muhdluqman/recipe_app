import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class RecipeType {
  final int id;
  final String name;

  RecipeType({required this.id, required this.name});

  factory RecipeType.fromJson(Map<String, dynamic> json) {
    return RecipeType(
      id: json['id'],
      name: json['name'],
    );
  }
}

Future<List<RecipeType>> loadRecipeTypes() async {
  final String jsonString = await rootBundle.loadString('assets/recipetypes.json');
  final List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((data) => RecipeType.fromJson(data)).toList();
}
