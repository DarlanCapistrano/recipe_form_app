import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:state_management_with_rxdart/enums.dart';
import 'package:state_management_with_rxdart/extensions.dart';
import 'package:state_management_with_rxdart/registration/registration_controller.dart';
import 'package:state_management_with_rxdart/registration/registration_model.dart';

class RegistrationPage extends StatefulWidget {
  final int formId;
  const RegistrationPage(this.formId, {Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final RegistrationController _registrationController = RegistrationController();

  String? category;

  @override
  void initState() {
    _registrationController.initFormRegistration(widget.formId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red),
      body: streamFormRegistration(),
      floatingActionButton: FloatingActionButton(
        child: const Text("Salvar"),
        onPressed: (){
          // registrationController.insertMealDatabase(category: category);
        }
      ),
    );
  }

  Widget streamFormRegistration(){
    return StreamBuilder<FormRegistration>(
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

  Widget bodyFormRegistration(FormRegistration form){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageItem(form),
          buildForm(form),
          expasionPanelItem(form, ItemRegistrationType.ingredientes),
          expasionPanelItem(form, ItemRegistrationType.passos),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget imageItem(FormRegistration form){
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

  Widget buildForm(FormRegistration form){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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

  Widget textFieldMealItem(FormRegistration form){
    return TextField(
      decoration: const InputDecoration(hintText: "ex: Ovo mexido", labelText: "Nome da receita"),
      onChanged: (text) => _registrationController.updateMealName(form, text),
    );
  }

  Widget dropDownCategoryItem(FormRegistration form){
    return DropdownButton<String>(
      hint: Text(form.category ?? "Categorias"),
      items: ["Italiano" , "Rápido & Fácil", "Hamburgers", "Alemã", "Leve & Saudável", "Exótica", "Café da Manhã","Asiática","Francesa", "Verão"].map((name) => DropdownMenuItem(child: Text(name), value: name)).toList(),
      onChanged: (newCategory) => _registrationController.updateCategory(form, newCategory),
    );
  }

  Widget textFieldDurationItem(FormRegistration form){
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

  Widget radioListItems(FormRegistration form, List<String> items, ItemRegistrationType radioType){
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

  Widget expasionPanelItem(FormRegistration form, ItemRegistrationType panelType){
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) => _registrationController.expandPanel(form, panelType),
      children: [
        ExpansionPanel(
          isExpanded: panelType == ItemRegistrationType.ingredientes ? form.ingredientIsExpanded : form.stepIsExpanded,
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded) => Text("Insira os ${panelType.name}"),
          body: const Text("TESTE")
        )
      ],
    );
  }
}