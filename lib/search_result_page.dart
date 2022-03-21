import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:health_app/ingrediant_input_page.dart';
import 'package:health_app/recipe_page.dart';
import 'BackendService/WebSraper.dart';

class AllRecipeReceiver {
  static SearchResult result = SearchResult();
}

class RecipeInfoDataPasser {
  static SearchResult result = SearchResult();
}

class SearchResultPage extends StatefulWidget {

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResultPage> {

  @override
  Widget build(BuildContext context) {

    print("============ printing from search result outter ============");
    print(AllRecipeReceiver.result.recipeNames);
    // print(RecipeInfoDataPasser.result.basicInfo);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            alignment: Alignment.center,
            child: const Text(
              "All results",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'AlfaSlabOne',
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AllRecipeReceiver.result.recipeNames.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 260,
                  height: 100,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.blueAccent)
                  // ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shadowColor: MaterialStateProperty.all(Colors.black),
                        maximumSize: MaterialStateProperty.all(const Size(240, 40)),
                      ),
                      onPressed: () async {
                        // RecipeInfoDataPasser.result = SearchResult(recipeURL: AllRecipeReceiver.result.recipePageURLs[index]);
                        // print("========== printing from search result page ==========");
                        // print(RecipeInfoDataPasser.result.prepTime);
                        RecipePageInfoReceiver.recipeURL = AllRecipeReceiver.result.recipePageURLs[index];
                        RecipePageInfoReceiver().getBasicInfo();
                        RecipePageInfoReceiver().getIngredients();
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecipePage()),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 33,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(AllRecipeReceiver.result.imageURLs[index]),
                                radius: 30,
                              ),
                            ),
                          ),
                          Container(
                            width: 235,
                            margin: const EdgeInsets.only(left: 30),
                            child: Text(
                              AllRecipeReceiver.result.recipeNames[index],
                              style: const TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                   );

                },
              ),

            ),
        ],
      ),
    );

      // ListView(
  }
}

