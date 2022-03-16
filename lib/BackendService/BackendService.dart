import 'dart:math';

class BackendService {
  static Future<List> getSuggestions(String query) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    });
  }
}

class IngrediantService {
  static final List<String> ingrediants = [
    'watermelon',
    'apple',
    'pork',
    'meat',
    'banana',
    'cucumber',
    'tomato',
    'potato',
    'butter',
    'egg',
    'garlic',
    'onion',
    'tofu',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(ingrediants);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}