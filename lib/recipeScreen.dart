import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recipe_app/recipeScreen/recipeAdd.dart';
import 'package:recipe_app/recipeScreen/recipeScreenDetail.dart';
import 'RecipeController.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final RecipeController controller = Get.put(RecipeController());
  String? selectedType = 'All'; // Default selected filter option
  List<String> recipeTypes = ['All', 'Dessert', 'Main Course', 'Appetizer']; // Example recipe types

  // Function to filter recipes based on selected type
  List filterRecipes() {
    if (selectedType == 'All') {
      return controller.recipes;
    }
    return controller.recipes
        .where((recipe) => recipe.recipeType == selectedType)
        .toList();
  }

  // Function to show the popup list for selecting recipe type
  void showRecipeTypeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: recipeTypes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(recipeTypes[index]),
              onTap: () {
                setState(() {
                  selectedType = recipeTypes[index]; // Update selected type
                });
                Navigator.pop(context); // Close the modal after selection
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: [

          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              showRecipeTypeSelector();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(AddRecipeScreen());
            },
          )
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: Obx(() {
              final filteredRecipes = filterRecipes(); // Get the filtered recipes

              if (filteredRecipes.isEmpty) {
                return Center(child: Text('No recipes found.'));
              }

              return ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(RecipeDetailScreen(recipe: recipe, index: index));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(recipe.name,),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(DateTime.parse(recipe.id)),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                      child: Text(recipe.recipeType,style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(recipe.recipeType),
                    onTap: () {
                      // Navigate to Recipe Detail Screen
                      Get.to(RecipeDetailScreen(recipe: recipe, index: index));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
