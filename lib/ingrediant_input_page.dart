import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_app/search_result_page.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import 'package:flutter_tags/flutter_tags.dart';

class SearchResult extends ingredientTags{
  late WebScraper spider;
  late List<String> recipeNames;
  late List<String> imageURLs;

  SearchResult() {
    WebScraper spider = WebScraper();
    spider.extractData();
    recipeNames = spider.recipeNames;
    imageURLs = spider.imageURLs;
  }

}

class WebScraper{

  List<String> recipeNames = [];
  List<String> imageURLs = [];

  bool isLoading = false;

  extractData() async {
    // print("=========== Printing tags ===========");
    // print(SearchResult().tagsForSearch);
    final response = await http.Client().get(Uri.parse("https://www.allrecipes.com/search/results/?search=apple"));

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
      try {
        var allNames = document.getElementsByClassName('component card card__recipe card__facetedSearchResult');
        var allImages = document.getElementsByClassName('card__titleLink manual-link-behavior elementFont__title margin-8-bottom');
        print("======= length from WebScraper =======");
        print(allImages.length);
        for (int i = 0; i < allNames.length; i++) {
          String recipeName = allNames[i].children[1].children[0].children[0].children[0].text.trim();
          // print("===========================Printing Content===========================");
          // print(recipeName);
          recipeNames.add(recipeName);
        }
        for (int i = 0; i < allImages.length; i++) {
          String? imageURL = allImages[i].children[0].attributes['data-src'];
          // print("===========================Printing Content===========================");
          // print(imageURL);
          imageURLs.add(imageURL as String);
          // imageURLs.add('https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F54867.jpg&w=272&h=272&c=sc&poi=face&q=60');
        }
      } catch (e) {
        return ;
      }
    }
    // return recipes;
  }
}

class DataPasser {
  static SearchResult result = SearchResult();
}


class IngredientInputPage extends StatefulWidget {
  @override
  _IngredientInputPageState createState() => _IngredientInputPageState();
}

class ingredientTags extends StatefulWidget {
  @override
  _IngredientInputPageState createState() => _IngredientInputPageState();
}

class _IngredientInputPageState extends State<IngredientInputPage> {
  List<String> tagsList = ['watermelon', 'apple', 'pork', 'meat', 'banana', 'cucumber', 'tomato', 'potato', 'butter', 'egg', 'garlic', 'onion', 'tofu'];
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 150,
            ),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () async {
                  DataPasser.result = SearchResult();
                  print("========== printing from ingredient input page ==========");
                  print(DataPasser.result.recipeNames);
                  DataReceiver.result = DataPasser.result;
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchResultPage()),
                  );
                },
                child: const Text("Submit"),
              ),
            ),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  onSubmitted: (val) {
                    // print('runtimetype of val is ${val.runtimeType}');
                    _addSuggestion(val);

                  }
              ),
              hideOnLoading: true,
              hideOnEmpty: true,
              getImmediateSuggestions: false,
              onSuggestionSelected: (val) {
                _onSuggestionSelected<String>(val as String);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion as String,
                  ),
                );
              },
              suggestionsCallback: (val) {
                return _sugestionList(
                  tags: tagsList,
                  suggestion: val,
                );
//                return ;
              },
            ),
            SizedBox(
              height: 20,
            ),
            _generateTags()
          ],
        ),
      ),
    );
  }

  _onSuggestionRemoved(String value) {
    final String exists =
    selectedTags.firstWhere((text) => text == value, orElse: () {
      return "NE";
    });
    if (exists != "NE") {
      setState(() {
        selectedTags.remove(value);
        tagsList.add(value);
      });
    }
  }
  _addSuggestion(String value) {
    final String exists = tagsList.firstWhere((text) => text ==value,orElse: () {return "NE";});
    if(exists != "NE") {
      final String isAlreadyInSelectedList = selectedTags.firstWhere((text) => text ==value,orElse: () {return "NE";});
      if(isAlreadyInSelectedList == "NE") {
        setState(() {
          selectedTags.add(value);
          tagsList.remove(value);
        });
      }
    }
    else {
      final String isAlreadyInSelectedList = selectedTags.firstWhere((text) => text==value,orElse: () {return "NE";});
      if(isAlreadyInSelectedList == "NE") {
        setState(() {
          selectedTags.add(value);
//          tagsList.add(value);
        });
      }
    }
  }

  _onSuggestionSelected<T>(T value) {
    final String exists =
    tagsList.firstWhere((text) => text == value, orElse: () {
      return "NE";
    });
    if (exists != "NE") {
      final String isAlreadyInSelectedList =
      selectedTags.firstWhere((text) => text == value, orElse: () {
        return "NE";
      });

      if (isAlreadyInSelectedList == "NE") {
        setState(() {
          selectedTags.add(value as String);
          tagsList.remove(value);
        });
      }
    }
  }

  _sugestionList({required List<String> tags, required String suggestion}) {
    List<String> modifiedList = [];
    modifiedList.addAll(tags);
    modifiedList.retainWhere(
            (text) => text.toLowerCase().contains(suggestion.toLowerCase()));
    if (suggestion.length >= 2) {
      return modifiedList;
    } else {
      return null;
    }
  }

  _generateTags() {
    return selectedTags.isEmpty
        ? Container()
        : Container(
          alignment: Alignment.topLeft,
          child: Tags(
            alignment: WrapAlignment.center,
            itemCount: selectedTags.length,
            itemBuilder: (index) {
              return ItemTags(
                index: index,
                title: selectedTags[index],
                color: Colors.blue,
                activeColor: Colors.red,
                onPressed: (Item item) {
                  print('pressed');
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                elevation: 0.0,
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
    //                textColor: ,
                textColor: Colors.white,
                textActiveColor: Colors.white,
                removeButton: ItemTagsRemoveButton(
                    color: Colors.black,
                    backgroundColor: Colors.transparent,
                    size: 14,
                    onRemoved: () {
                      _onSuggestionRemoved(selectedTags[index]);
                      return true;
                    }),
                textOverflow: TextOverflow.ellipsis,
              );
            },
          ),
       );
  }
}