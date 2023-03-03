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
      appBar: AppBar(backgroundColor: Colors.red, title: const Text("Receitas")),
    floatingActionButton: FloatingActionButton(onPressed: () => _recipesController.goToFormRegistratrion(context), child: const Icon(Icons.add)),
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
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(color: Colors.grey),
      itemCount: recipes.length,
      itemBuilder: (context, index) => recipeItem(recipes[index]),
    );
  }

  Widget recipeItem(Recipe recipe){
    return Container(
      margin: const EdgeInsets.only(left: 4, bottom: 4),
      child: Column(
        children: [
          Text(recipe.mealName ?? "", style: const TextStyle(fontSize: 16)),
          Text(recipe.startedTime.toString(), style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}