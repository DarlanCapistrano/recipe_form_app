class FormRegistration {
  final int? id;
  String? mealName;
  String? category;
  String? imgUrl;
  double? duration;
  String? difficulty;
  String? cost;
  bool? isFavorited;
  bool ingredientIsExpanded;
  bool stepIsExpanded;
  List<Ingredient> ingredients;
  List<Step> steps;
  FormRegistration({this.mealName, this.category, this.imgUrl, this.duration, this.difficulty, this.isFavorited, this.cost, this.id, this.ingredientIsExpanded = false, this.stepIsExpanded = false, this.steps = const [], this.ingredients = const []});

  factory FormRegistration.fromMap(Map<String, dynamic> map){
    return FormRegistration(
      id: map["id"],
      category: map["category"],
      cost: map["cost"],
      difficulty: map["difficulty"],
      duration: map["duration"],
      imgUrl: map["imgUrl"],
      mealName: map["mealName"],
      isFavorited: map["isFavorited"],
    );
  }
}

class Ingredient{
  final int? id;
  final int? mealId;
  final String? name;
  const Ingredient({this.id, this.mealId, this.name});

  factory Ingredient.fromMap(Map<String, dynamic> map){
    return Ingredient(
      id: map["id"],
      mealId: map["mealId"],
      name: map["name"],
    );
  }

  static fromMapList(List<Map<String, dynamic>> ingredient){
    return ingredient.map((e) => Ingredient.fromMap(e)).toList();
  }
}

class Step{
  final int? id;
  final int? mealId;
  final String? name;
  const Step({this.id, this.mealId ,this.name});

  factory Step.fromMap(Map<String, dynamic> map){
    return Step(
      id: map["id"],
      mealId: map["mealId"],
      name: map["name"],
    );
  }

  static fromMapList(List<Map<String, dynamic>> step){
    return step.map((e) => Step.fromMap(e)).toList();
  }
}