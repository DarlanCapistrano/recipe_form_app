class Recipe {
  String? mealName;
  String? startedTime;
  String? category;
  String? imgPath;
  double? duration;
  String? difficulty;
  String? cost;
  bool? isFavorited;
  bool ingredientIsExpanded = false;
  List<Ingredient> ingredients = [];
  Recipe({this.mealName, this.category, this.imgPath, this.duration, this.difficulty, this.isFavorited, this.cost});
}

class Ingredient{
  final String? name;
  const Ingredient({this.name});
}