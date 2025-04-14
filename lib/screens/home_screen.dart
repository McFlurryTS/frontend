import 'package:demo/providers/recipes_provider.dart';
import 'package:demo/screens/recipe_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(
      context,
      listen: false,
    );
    recipesProvider.fetchRecipes();
    return Scaffold(
      body: Consumer<RecipesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.recipes.isEmpty) {
            return const Center(child: Text('No recipes found'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16), // Espaciado entre filas
                SizedBox(
                  height: 120, // Altura de la fila de tarjetas
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Desliza horizontalmente
                    itemCount: provider.recipes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.network(
                                provider.recipes[index].image_link,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[400],
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sección',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16), // Espaciado entre filas
                Text(
                  '  Cupones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 160, // Altura de la fila de tarjetas
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Desliza horizontalmente
                    itemCount: provider.recipes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _RecipesCard(context, provider.recipes[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16), // Espaciado entre filas
                Text(
                  '  Menus',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 120, // Altura de la fila de tarjetas
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Desliza horizontalmente
                    itemCount: provider.recipes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _RecipesCard(context, provider.recipes[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16), // Espaciado entre filas
                Text(
                  '  Mas secciones quí',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Agrega más widgets o filas aquí según sea necesario
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showButtom(context);
        },
      ),
    );
  }

  Future<void> _showButtom(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 650,
                width: MediaQuery.of(context).size.width,
                child: const ReciperForm(),
              ),
            ),
          ),
    );
  }

  Widget _RecipesCard(BuildContext context, dynamic recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    RecipeDetail(recipe: recipe), // Envía el modelo completo
          ),
        );
      },
      child: Container(
        width: 300, // Ancho de la tarjeta
        height: 100, // Alto de la tarjeta
        child: Card(
          child: Row(
            children: <Widget>[
              Container(
                height: 90, // Alto de la imagen
                width: 90, // Ancho de la imagen
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    recipe.image_link,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200], // Fondo de reserva
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                          size: 50,
                        ), // Icono de marcador de posición
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16), // Espaciado entre la imagen y el texto
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    recipe.name,
                    style: TextStyle(fontSize: 16, fontFamily: 'Quicksand'),
                    overflow: TextOverflow.ellipsis, // Maneja texto largo
                  ),
                  const SizedBox(height: 4),
                  Container(height: 2, width: 75, color: Colors.orange),
                  Text(
                    'By ${recipe.author}',
                    style: TextStyle(fontSize: 16, fontFamily: 'Quicksand'),
                    overflow: TextOverflow.ellipsis, // Maneja texto largo
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

class ReciperForm extends StatelessWidget {
  const ReciperForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _recipeName = TextEditingController();
    final TextEditingController _recipeAuthor = TextEditingController();
    final TextEditingController _recipeImage = TextEditingController();
    final TextEditingController _recipeIngredients = TextEditingController();
    final TextEditingController _recipeSteps = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Recipe',
              style: TextStyle(fontSize: 24, color: Colors.orange),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeName,
              label: 'Recipe Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a recipe name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              maxLines: 1,
              controller: _recipeAuthor,
              label: 'Author Recipe',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a author recipe';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeImage,
              label: 'Image URL',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a image url';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              maxLines: 1,
              controller: _recipeIngredients,
              label: 'Recipe Ingredients',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a recipe ingredients';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              maxLines: 4,
              controller: _recipeSteps,
              label: 'Recipe Steps',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a recipe steps';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save Recipe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.orange, fontFamily: 'Quicksand'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.orange, width: 1),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}
