import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:state_management_with_rxdart/registration/registration_model.dart';
import 'package:state_management_with_rxdart/registration/ui/registration_page.dart';

class RecipesController {
  final controllerRecipes = BehaviorSubject<List<Recipe>>();

  void initRecipesPage(){
    controllerRecipes.sink.add([]);
  }

  void goToFormRegistratrion(BuildContext context) async {
    Recipe? recipe = await Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationPage()));
    if(recipe != null){
      var recipes = controllerRecipes.stream.value;
      recipes.add(recipe);
      controllerRecipes.sink.add(recipes);
    }
  }
}