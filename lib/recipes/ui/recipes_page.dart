import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_form_app/recipes/recipes_controller.dart';
import 'package:recipe_form_app/registration/registration_model.dart';

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
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent, colorScheme: Theme.of(context).colorScheme.copyWith(primary: Colors.yellow[700])),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.yellowAccent[700], title: const Text("Receitas", style: TextStyle(color: Colors.black))),
      floatingActionButton: FloatingActionButton(onPressed: () => _recipesController.goToFormRegistratrion(context), child: const Icon(Icons.add, color: Colors.black), backgroundColor: Colors.yellow[700]),
        body: streamRecipes(),
      ),
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
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ListView.separated(
        separatorBuilder: (context, index) => Container(color: Colors.grey, height: 1),
        itemCount: recipes.length,
        itemBuilder: (context, index) => recipeItem(recipes[index]),
      ),
    );
  }

  Widget recipeItem(Recipe recipe){
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(vertical: 8),
      title: Row(
        children: [
          imageRecipeItem(recipe.imgPath),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(recipe.mealName ?? "Nome indisponível", style: const TextStyle(fontSize: 16, color: Colors.black87)),
              Text("${recipe.difficulty ?? ""} - ${recipe.cost ?? ""}", style: const TextStyle(fontSize: 16, color: Colors.black87)),
            ],
          ),
        ],
      ),
      children: [expandedPanelList(recipe)],
    );
  }

  Widget expandedPanelList(Recipe recipe){
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 8),
      separatorBuilder: (context, index) => const SizedBox(height: 1),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recipe.ingredients.length,
      itemBuilder: (context, index) => expandedPanelItem(recipe.ingredients[index]),
    );
  }

  Widget expandedPanelItem(Ingredient ingredient){
    return Container(
      margin: const EdgeInsets.only(left: 80, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("- ${ingredient.name ?? ""}", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget imageRecipeItem(String? path){
    bool hasImage = File("$path").existsSync();
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 60,
      width: 60,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1), image: hasImage ? DecorationImage(image: FileImage(File(path!)), fit: BoxFit.cover) : null),
      child: !hasImage ? const Icon(Icons.fastfood_outlined, size: 30) : null,
    );
  }
}