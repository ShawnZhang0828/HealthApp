import 'WebSraper.dart';

class RecipeSorter {
  List<String> recipeNames;
  List<String> imageURLs;
  List<String> recipePageURLs;

  RecipeSorter(this.recipeNames, this.imageURLs, this.recipePageURLs);

  getAllCalories () async {
    List<int> calorieList = [];
    for (int i = 0; i < recipePageURLs.length; i++) {
      calorieList.add(await WebScraper().extractCalories(recipePageURLs[i]));
    }

    return calorieList;
  }

  sortByCalories () async {
    List<int> recipeCalories = await getAllCalories();

    Map<int, List<List<String>>> mapping = getRelationMapping(recipeCalories);

    recipeNames = [];
    imageURLs = [];
    recipePageURLs = [];

    recipeCalories.sort();

    for (int recipeCalorie in recipeCalories) {
      List<List<String>>? infoLists = mapping[recipeCalorie];
      for (List<String> infoList in infoLists!) {
        recipeNames.add(infoList[0]);
        imageURLs.add(infoList[1]);
        recipePageURLs.add(infoList[2]);
      }
    }

    print("done sorting");
  }

  void addValueToMap<K,V> (Map<K, List<List<V>>> map, K key, List<V> value) =>
    map.update(key, (list) => list..add(value), ifAbsent: () => [value]);

  getRelationMapping (List<int> calorieList) {
    final Map<int, List<List<String>>> mapping = {};

    for (int i = 0; i < calorieList.length; i++) {
      addValueToMap(mapping, calorieList[i], [recipeNames[i], imageURLs[i], recipePageURLs[i]]);
    }

    return mapping;
  }

}