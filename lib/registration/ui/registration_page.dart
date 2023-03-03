import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:state_management_with_rxdart/enums.dart';
import 'package:state_management_with_rxdart/extensions.dart';
import 'package:state_management_with_rxdart/registration/registration_controller.dart';
import 'package:state_management_with_rxdart/registration/registration_model.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final RegistrationController _registrationController = RegistrationController();
  final categoryTypesList = const ["Italiano" , "Rápido", "Hamburgers", "Alemã", "Saudável", "Exótica", "Café da Manhã", "Asiática", "Francesa", "Verão"];

  @override
  void initState() {
    _registrationController.initFormRegistration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [IconButton(onPressed: () => _registrationController.finishFormRegistration(context), icon: const Icon(Icons.check))],
        title: const Text("Cadastrar receita"),
      ),
      body: streamFormRegistration(),
    );
  }

  Widget streamFormRegistration(){
    return StreamBuilder<Recipe>(
      stream: _registrationController.controllerFormRegistration.stream,
      builder: (context, snapshot) {
        if(snapshot.data != null){
          return bodyFormRegistration(snapshot.data!);
        } else{
          return const CircularProgressIndicator();
        }
      }
    );
  }

  Widget bodyFormRegistration(Recipe form){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageItem(form),
          buildForm(form),
          expasionPanelWidget(form),
        ],
      ),
    );
  }

  Widget imageItem(Recipe form){
    return InkWell(
      onTap: () => _registrationController.clickAddImage(form),
      child: form.imgUrl == null 
      ? Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, size: 60),
            Text("Adicione uma imagem", style: TextStyle(fontSize: 27))
          ]
        ),
      ) : SizedBox(
        height: 300,
        width: double.infinity,
        child: Image.file(File(form.imgUrl!), fit: BoxFit.cover)
      ),
    );
  }

  Widget buildForm(Recipe form){
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldMealItem(form),
          const SizedBox(height: 10),
          dropDownCategoryItem(form),
          textFieldDurationItem(form),
          radioListItems(form, ["Fácil", "Médio", "Difícil"], ItemRegistrationType.dificuldade),
          radioListItems(form, ["Barato", "Razoável", "Caro"], ItemRegistrationType.custo),
        ],
      ),
    );
  }

  Widget textFieldMealItem(Recipe form){
    return TextField(
      decoration: const InputDecoration(labelText: "Nome da receita"),
      onChanged: (text) => _registrationController.updateMealName(form, text),
    );
  }

  Widget dropDownCategoryItem(Recipe form){
    return DropdownButton<String>(
      hint: Text(form.category ?? "Categorias"),
      items: categoryTypesList.map((name) => DropdownMenuItem(child: Text(name), value: name)).toList(),
      onChanged: (newCategory) => _registrationController.updateCategory(form, newCategory),
    );
  }

  Widget textFieldDurationItem(Recipe form){
    return SizedBox(
      width: 150,
      child: Form(
        key: _registrationController.formKey,
        child: TextFormField(
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp ("[,]"))],
          decoration: const InputDecoration(labelText: "Tempo", hintText: "ex: 12 min"),
          onChanged: (text) => _registrationController.updateDuration(form, text),
          validator: (text){
            if(double.tryParse("$text".replaceAll(",", ".")) == null){
              return "Tempo inválido";
            }
            return null;
          },
        ),
      )
    );
  }

  Widget radioListItems(Recipe form, List<String> items, ItemRegistrationType radioType){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: Text(radioType.name.capitalize(), style: const TextStyle(fontSize: 22)),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index){
            return RadioListTile<String>(
              title: Text(items[index]),
              value: items[index],
              groupValue:  radioType == ItemRegistrationType.dificuldade ? form.difficulty : form.cost,
              onChanged: (value) => _registrationController.updateRadioItem(form, radioType, value)
            );
          },
        ),
      ],
    );
  }

  Widget buildListView(List list){
    return SizedBox(
      height: 200,
      width: 100,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) => ListTile(title: Text(list[index].name)), 
      ),
    );
  }

  Widget expasionPanelWidget(Recipe form){
    final textController = TextEditingController();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) => _registrationController.expandPanel(form),
        children: [
          ExpansionPanel(
            isExpanded: form.ingredientIsExpanded,
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) => const Padding(padding: EdgeInsets.only(left: 10, top: 15), child: Text("Insira os ingredientes")),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  expandedPanelList(form),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Adicionar ingrediente",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(onPressed: () => _registrationController.addIngredient(form, textController), icon: const Icon(Icons.add)),
                    ),
                    controller: textController,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget expandedPanelList(Recipe form){
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(color: Colors.grey),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: form.ingredients.length,
      itemBuilder: (context, index) => expandedPanelItem(form, form.ingredients[index]),
    );
  }

  Widget expandedPanelItem(Recipe form, Ingredient ingredient){
    return Container(
      margin: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(ingredient.name ?? "", style: const TextStyle(fontSize: 16)),
          IconButton(onPressed: () => _registrationController.removeIngredient(form, ingredient), icon: const Icon(Icons.delete))
        ],
      ),
    );
  }
}