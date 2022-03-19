import 'package:flutter/material.dart';
import 'package:health_app/search_result_page.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'BackendService/WebSraper.dart';

List<String> tagsList = ['watermelon', 'apple', 'pork', 'meat', 'banana', 'cucumber', 'tomato', 'potato', 'butter', 'egg', 'garlic', 'onion', 'tofu'];
List<String> selectedTags = [];

class AllRecipeDataPasser {
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
                  AllRecipeDataPasser.result = SearchResult();
                  // print("========== printing from ingredient input page ==========");
                  // print(AllRecipeDataPasser.result.recipeNames);
                  AllRecipeReceiver.result = AllRecipeDataPasser.result;
                  await Future.delayed(const Duration(seconds: 3));
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