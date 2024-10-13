import 'package:hive/hive.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String recipeType;

  @HiveField(3)
  String imagePath;

  @HiveField(4)
  List<String> ingredients;

  @HiveField(5)
  List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.recipeType,
    required this.imagePath,
    required this.ingredients,
    required this.steps,
  });
}
