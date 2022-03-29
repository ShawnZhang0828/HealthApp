import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/search_result_page.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'BackendService/RecipeSort.dart';
import 'BackendService/WebSraper.dart';
import 'BackendService/SetPreference.dart';
import 'main_page.dart';

enum ButtonState { init, loading, done }

List<String> tagsList = ['watermelon', 'apple', 'pork', 'beef', 'banana', 'cucumber', 'tomato', 'potato', 'butter', 'egg', 'garlic', 'onion', 'tofu',
  'milk', 'chicken wing', 'honey', 'lettuce', 'gingers', 'broccoli', 'celery', 'cabbages', 'asparagus', 'carrots', 'eggplant', 'mushrooms',
  'peas', 'corn', 'chicken thigh', 'bamboo shoots', 'cassava', 'leeks', 'pepper', 'pumpkin', 'radicchio', 'yam root', 'flour', 'salmon', 'steak', 'shrimps',
  'avocado', 'beef ribs', 'chicken breast', 'crab', 'cauliflower', 'pepper', 'cilantro', 'french beans'];
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

  ButtonState state = ButtonState.init;
  int sortDelay = 15;

  Widget loadingSpinner(bool isDone) {
    return Container(
      // width: 30,
      // height: 30,
      margin: const EdgeInsets.only(right: 10),
      child: isDone
        ? doneIcon()
        : const CircularProgressIndicator(color: Color(0xff8ca875)),
    );
  }

  Widget doneIcon () {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: const Icon(
        Icons.check_circle_outline,
        color: Color(0xff8ca875),
        size: 32,
      ),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style,
      onPressed: () async {
        setState(() => state = ButtonState.loading);

        AllRecipeDataPasser.result = SearchResult();
        // print("========== printing from ingredient input page ==========");
        // print(AllRecipeDataPasser.result.recipeNames);
        AllRecipeReceiver.result = AllRecipeDataPasser.result;

        await Future.delayed(const Duration(seconds: 2));

        RecipeSorter sorter = RecipeSorter(AllRecipeReceiver.result.recipeNames, AllRecipeReceiver.result.imageURLs, AllRecipeReceiver.result.recipePageURLs);
        String preference = await PreferenceSetter.readString("Target_Plan");
        print(preference);
        if (preference == "Weight Loss") {
          sorter.sortByCalories();

          await Future.delayed(Duration(seconds: sortDelay));

          setState(() => state = ButtonState.done);
          await Future.delayed(const Duration(seconds: 2));
          setState(() => state = ButtonState.init);

          AllRecipeReceiver.result.recipeNames = sorter.recipeNames;
          AllRecipeReceiver.result.imageURLs = sorter.imageURLs;
          AllRecipeReceiver.result.recipePageURLs = sorter.recipePageURLs;
          print(AllRecipeReceiver.result.recipeNames);
        } else if (preference == "Muscle Gain") {
          sorter.sortByProtein();

          await Future.delayed(Duration(seconds: sortDelay));

          setState(() => state = ButtonState.done);
          await Future.delayed(const Duration(seconds: 2));
          setState(() => state = ButtonState.init);

          AllRecipeReceiver.result.recipeNames = sorter.recipeNames;
          AllRecipeReceiver.result.imageURLs = sorter.imageURLs;
          AllRecipeReceiver.result.recipePageURLs = sorter.recipePageURLs;
          print(AllRecipeReceiver.result.recipeNames);
        } else if (preference == "Default Plan") {
          setState(() => state = ButtonState.done);
          await Future.delayed(const Duration(seconds: 1));
          setState(() => state = ButtonState.init);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchResultPage()),
        );
      },
      child: Text(
        "Submit",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final isInit = state == ButtonState.init;
    final isDone = state == ButtonState.done;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter Ingredients',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor:Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage())),
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 150,
            ),
            Align(
              alignment: Alignment.topRight,
              child: isInit ? submitButton() : loadingSpinner(isDone),
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