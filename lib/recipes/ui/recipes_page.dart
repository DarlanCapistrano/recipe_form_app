import 'dart:io';
import 'package:flutter/material.dart';
import 'package:state_management_with_rxdart/recipes/recipes_controller.dart';
import 'package:state_management_with_rxdart/registration/registration_model.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final _recipesController = RecipesController();

  @override
  void initState() {
    _recipesController.initRecipesPage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red[800], title: const Text("Receitas")),
    floatingActionButton: FloatingActionButton(onPressed: () => _recipesController.goToFormRegistratrion(context), child: const Icon(Icons.add), backgroundColor: Colors.red[600],),
      body: streamRecipes(),
    );
  }

  Widget streamRecipes(){
    return StreamBuilder<List<Recipe>>(
      stream: _recipesController.controllerRecipes.stream,
      builder: (context, snapshot) {
        if(snapshot.data != null){
          if(snapshot.data!.isNotEmpty){
            return bodyRecipes(snapshot.data!);
          } else {
            return const Center(
              child: Text("Nenhuma receita disponível"),
            );
          }
        } else{
          return const CircularProgressIndicator();
        }
      }
    );
  }

  Widget bodyRecipes(List<Recipe> recipes){
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: ListView.separated(
        separatorBuilder: (context, index) => Container(color: Colors.grey, height: 1),
        itemCount: recipes.length,
        itemBuilder: (context, index) => recipeItem(recipes[index]),
      ),
    );
  }

  Widget recipeItem(Recipe recipe){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          imageRecipeItem(recipe.imgPath),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(recipe.mealName ?? "Nome indisponível", style: const TextStyle(fontSize: 16)),
              Text("${recipe.difficulty ?? ""} - ${recipe.cost ?? ""}", style: const TextStyle(fontSize: 16)),
              Text(recipe.startedTime.toString(), style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget imageRecipeItem(String? path){
    bool hasImage = File("$path").existsSync();
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 70,
      width: 70,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1), image: hasImage ? DecorationImage(image: FileImage(File(path!)), fit: BoxFit.cover) : null),
      child: !hasImage ? const Icon(Icons.fastfood_outlined) : null,
    );
  }
}