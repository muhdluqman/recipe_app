import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../RecipeController.dart';
import '../model/recipe.dart';

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

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final RecipeController controller = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();

  String? selectedRecipeType;
  File? imageFile;

  List<RecipeType> recipeTypes = [];

  @override
  void initState() {
    super.initState();
    loadRecipeTypes();
  }

  Future<void> loadRecipeTypes() async {
    final String jsonString = await rootBundle.loadString('assets/recipetypes.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    setState(() {
      recipeTypes = jsonResponse.map((data) => RecipeType.fromJson(data)).toList();
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  bool validateForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter the recipe name');
      return false;
    }
    if (selectedRecipeType == null) {
      Get.snackbar('Error', 'Please select a recipe type');
      return false;
    }
    if (ingredientsController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter ingredients');
      return false;
    }
    if (stepsController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter steps');
      return false;
    }
    return true;
  }

  // Reusable TextFormField builder
  Widget buildNewTextFormField({
    required TextEditingController controller,
    required String hint,
    TextInputType? inputType,
    Icon? prefixIcon,
    int? maxLines = 1,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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
        title: Text('Add Recipe'),
      ),
      // Adding SingleChildScrollView to enable scrolling
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Recipe Name field
              buildNewTextFormField(
                controller: nameController,
                hint: 'Recipe Name',
              ),

              // Dropdown for selecting Recipe Type with hint
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 15, 16, 0),
                child: DropdownButtonFormField<String>(
                  value: selectedRecipeType,
                  hint: Text(
                    'Select Recipe Type',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF606A85), // Hint color
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Select Recipe Type',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000), // Transparent border
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(36), // Match border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF6F61EF), // Focused border color
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(36), // Match border radius
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFFF5963), // Error border color
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(36), // Match border radius
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFFF5963), // Focused error border color
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(36), // Match border radius
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    filled: true,
                    fillColor: Colors.white, // Add this to match the background fill
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  iconSize: 24, // Set a smaller arrow size if necessary
                  items: recipeTypes.map((RecipeType type) {
                    return DropdownMenuItem<String>(
                      value: type.name,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRecipeType = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),

              // Ingredients field
              buildNewTextFormField(
                controller: ingredientsController,
                hint: 'Ingredients',
                maxLines: 3,
              ),

              // Steps field
              buildNewTextFormField(
                controller: stepsController,
                hint: 'Steps',
                maxLines: 3,
              ),

              // Updated Image Picker UI
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 16),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E3E7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          color: Color(0xFF57636C),
                          size: 72,
                        ),
                        onPressed: _pickImage,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Add Image',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Pick an image from the gallery.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF57636C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (imageFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            imageFile!.path.split('/').last, // Display the file name
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Add Recipe Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Validate the form before adding the recipe
                      if (validateForm()) {
                        final newRecipe = Recipe(
                          id: DateTime.now().toString(),
                          name: nameController.text,
                          recipeType: selectedRecipeType!,
                          imagePath: imageFile?.path ?? '', // Optional: if image is not selected, pass empty string
                          ingredients: ingredientsController.text.split(',').map((e) => e.trim()).toList(),
                          steps: stepsController.text.split(',').map((e) => e.trim()).toList(),
                        );
                        controller.addRecipe(newRecipe);
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, // Text color
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Padding inside button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                      elevation: 5, // Shadow elevation
                      shadowColor: Colors.black.withOpacity(0.3), // Shadow color
                    ),
                    child: Text(
                      'Add Recipe',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
