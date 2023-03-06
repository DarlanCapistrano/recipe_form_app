import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:state_management_with_rxdart/enums.dart';
import 'package:state_management_with_rxdart/registration/registration_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/subjects.dart';

class RegistrationController {

  BehaviorSubject<Recipe> controllerFormRegistration = BehaviorSubject<Recipe>();

  final formKey = GlobalKey<FormState>();

  void initFormRegistration(){
    var recipe = Recipe();
    recipe.startedTime = DateFormat("dd/MM/yy").format(DateTime.now()) + " às " + DateFormat("hh:mm").format(DateTime.now());
    controllerFormRegistration.sink.add(recipe);
  }

  Future<void> clickAddImage(Recipe form) async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if(image != null){
      form.imgPath = image.path;
      controllerFormRegistration.sink.add(form);
    }
  }

  void updateMealName(Recipe form, String text){
    form.mealName = text;
    controllerFormRegistration.sink.add(form);
  }

  void updateDuration(Recipe form, String text){
    if(formKey.currentState!.validate()){
      form.duration = double.parse(text.replaceAll(",", "."));
      controllerFormRegistration.sink.add(form);
    }
  }

  void updateCategory(Recipe form, String? newCategory){
    form.category = newCategory;
    controllerFormRegistration.sink.add(form);
  }

  void updateRadioItem(Recipe form, ItemRegistrationType radioType, String? value){
    if(radioType == ItemRegistrationType.dificuldade){
      form.difficulty = value;
    } else {
      form.cost = value;
    }
    controllerFormRegistration.sink.add(form);
  }

  void expandPanel(Recipe form){
    form.ingredientIsExpanded = !form.ingredientIsExpanded;
    controllerFormRegistration.sink.add(form);
  }

  void addIngredient(Recipe form, TextEditingController textController){
    if(textController.text.isNotEmpty){
      form.ingredients.add(Ingredient(name: textController.text));
      controllerFormRegistration.sink.add(form);
      textController.clear();
    }
  }

  void removeIngredient(Recipe form, Ingredient ingredient){
    form.ingredients.removeWhere((e) => e == ingredient);
    controllerFormRegistration.sink.add(form);
  }

  void finishFormRegistration(BuildContext context){
    Navigator.pop(context, controllerFormRegistration.stream.valueOrNull);
  }
}