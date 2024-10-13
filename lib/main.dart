import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'recipeScreen.dart';
import 'model/recipe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path); // Initialize Hive with app document directory
  Hive.registerAdapter(RecipeAdapter()); // Register Hive adapter for Recipe
  await Hive.openBox<Recipe>('recipes'); // Open Hive box for storing recipes
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipeListScreen(), // This is the initial screen for the app
    );
  }
}
