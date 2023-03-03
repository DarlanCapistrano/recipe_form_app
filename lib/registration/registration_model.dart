class Recipe {
  String? mealName;
  DateTime startedTime = DateTime.now();
  String? category;
  String? imgUrl;
  double? duration;
  String? difficulty;
  String? cost;
  bool? isFavorited;
  bool ingredientIsExpanded = false;
  List<Ingredient> ingredients = [];
  Recipe({this.mealName, this.category, this.imgUrl, this.duration, this.difficulty, this.isFavorited, this.cost});
}

class Ingredient{
  final String? name;
  const Ingredient({this.name});
}