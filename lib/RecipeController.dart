import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'model/recipe.dart';

class RecipeController extends GetxController {
  var recipes = <Recipe>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
  }

  void loadRecipes() async {
    var box = await Hive.openBox<Recipe>('recipes');
    recipes.value = box.values.toList();
  }


  void addRecipe(Recipe recipe) async {
    var box = await Hive.openBox<Recipe>('recipes');
    box.add(recipe);
    recipes.add(recipe);
  }


  void updateRecipe(int index, Recipe updatedRecipe) async {
    var box = await Hive.openBox<Recipe>('recipes');
    box.putAt(index, updatedRecipe);
    recipes[index] = updatedRecipe;
  }


  void deleteRecipe(int index) async {
    var box = await Hive.openBox<Recipe>('recipes');
    box.deleteAt(index);
    recipes.removeAt(index);
  }
}
