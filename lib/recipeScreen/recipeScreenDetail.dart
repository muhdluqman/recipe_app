import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../RecipeController.dart';
import '../model/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final int index;

  RecipeDetailScreen({required this.recipe, required this.index});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeController controller = Get.find();
  late TextEditingController nameController;
  late TextEditingController ingredientsController;
  late TextEditingController stepsController;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the current recipe data
    nameController = TextEditingController(text: widget.recipe.name);
    ingredientsController = TextEditingController(text: widget.recipe.ingredients.join(', '));
    stepsController = TextEditingController(text: widget.recipe.steps.join(', '));
  }

  // Function to update the recipe
  void updateRecipe() {
    final updatedRecipe = Recipe(
      id: widget.recipe.id,
      name: nameController.text,
      recipeType: widget.recipe.recipeType,
      imagePath: imageFile?.path ?? widget.recipe.imagePath, // Keep original image if not updated
      ingredients: ingredientsController.text.split(',').map((e) => e.trim()).toList(),
      steps: stepsController.text.split(',').map((e) => e.trim()).toList(),
    );

    controller.updateRecipe(widget.index, updatedRecipe);
    Get.back(); // Go back after saving
  }

  // Reusable TextFormField with custom UI
  Widget buildNewTextFormField({
    required TextEditingController controller,
    required String hint,
    TextInputType? inputType,
    Icon? prefixIcon,
    int? maxLines = 1,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF606A85), // Label color
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            color: Color(0xFF606A85), // Hint color
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000), // Transparent border
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(36), // Rounded border
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF6F61EF), // Focused border color
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(36),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFFF5963), // Error border color
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(36),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFFF5963), // Focused error border color
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(36),
          ),
          filled: true,
          fillColor: Colors.white, // Fill color for the input field
          prefixIcon: prefixIcon, // Existing prefixIcon
        ),
        style: TextStyle(
          fontFamily: 'Poppins',
          color: const Color(0xFF15161E), // Text color
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: Color(0xFF6F61EF), // Cursor color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Recipe'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              controller.deleteRecipe(widget.index); // Delete recipe
              Get.back();
            },
          )
        ],
      ),
      resizeToAvoidBottomInset: true, // Ensure the body resizes when the keyboard is up
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image picker or placeholder if image not provided
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        imageFile = File(pickedFile.path);
                      });
                    }
                  },
                  child: imageFile != null || widget.recipe.imagePath.isNotEmpty
                      ? Image.file(imageFile ?? File(widget.recipe.imagePath), height: 200, fit: BoxFit.cover)
                      : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),

                // Editable name field using custom TextFormField
                buildNewTextFormField(
                  controller: nameController,
                  hint: 'Recipe Name',
                ),

                // Editable ingredients field using custom TextFormField
                buildNewTextFormField(
                  controller: ingredientsController,
                  hint: 'Ingredients (comma-separated)',
                  maxLines: 3,
                ),

                // Editable steps field using custom TextFormField
                buildNewTextFormField(
                  controller: stepsController,
                  hint: 'Steps (comma-separated)',
                  maxLines: 3,
                ),

                // Save button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent, // Button text color
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Padding inside button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                        elevation: 5, // Shadow elevation
                        shadowColor: Colors.black.withOpacity(0.3), // Shadow color
                      ),
                      onPressed: updateRecipe,
                      child: Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
  }
}
