import 'package:flutter/widgets.dart';
import 'package:state_management_with_rxdart/enums.dart';
import 'package:state_management_with_rxdart/registration/registration_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/subjects.dart';

class RegistrationController {

  BehaviorSubject<FormRegistration> controllerFormRegistration = BehaviorSubject<FormRegistration>();

  final formKey = GlobalKey<FormState>();

  void initFormRegistration(int formId){
    controllerFormRegistration.sink.add(FormRegistration(id: formId));
  }

  Future<void> clickAddImage(FormRegistration form) async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if(image != null){
      form.imgUrl = image.path;
      controllerFormRegistration.sink.add(form);
    }
  }

  void updateMealName(FormRegistration form, String text){
    form.mealName = text;
    controllerFormRegistration.sink.add(form);
  }

  void updateDuration(FormRegistration form, String text){
    if(formKey.currentState!.validate()){
      form.duration = double.parse(text.replaceAll(",", "."));
      controllerFormRegistration.sink.add(form);
    }
  }

  void updateCategory(FormRegistration form, String? newCategory){
    form.category = newCategory;
    controllerFormRegistration.sink.add(form);
  }

  void updateRadioItem(FormRegistration form, ItemRegistrationType radioType, String? value){
    if(radioType == ItemRegistrationType.dificuldade){
      form.difficulty = value;
    } else {
      form.cost = value;
    }
    controllerFormRegistration.sink.add(form);
  }

  void expandPanel(FormRegistration form, ItemRegistrationType panelType){
    if(panelType == ItemRegistrationType.ingredientes){
      form.ingredientIsExpanded = !form.ingredientIsExpanded;
    } else {
      form.stepIsExpanded = !form.stepIsExpanded;
    }
    controllerFormRegistration.sink.add(form);
  }
}