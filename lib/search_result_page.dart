import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:health_app/ingrediant_input_page.dart';
import 'package:health_app/recipe_page.dart';
import 'BackendService/WebSraper.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Results",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Container(
        color: const Color.fromRGBO(207, 202, 209, 100),
        child: Column(
          children: [
            // Container(
            //   padding: const EdgeInsets.only(top: 30, bottom: 10),
            //   alignment: Alignment.center,
            //   child: const Text(
            //     "All results",
            //     style: TextStyle(
            //       fontSize: 30,
            //       fontFamily: 'AlfaSlabOne',
            //       color: Colors.black,
            //       decoration: TextDecoration.none,
            //     ),
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AllRecipeReceiver.result.recipeNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 260,
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 10),
                    padding: const EdgeInsets.all(3.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(127, 191, 164, 100)),
                          shadowColor: MaterialStateProperty.all(const Color.fromRGBO(85, 110, 70, 100)),
                          elevation: MaterialStateProperty.all(5),
                          maximumSize: MaterialStateProperty.all(const Size(240, 40)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          RecipePageInfoReceiver.recipeURL = AllRecipeReceiver.result.recipePageURLs[index];
                          RecipePageInfoReceiver().getBasicInfo();
                          RecipePageInfoReceiver().getIngredients();
                          RecipePageInfoReceiver().getDirections();
                          RecipePageInfoReceiver().getNutritionFacts();
                          await Future.delayed(const Duration(seconds: 4));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecipePage()),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: CachedNetworkImage(
                                imageUrl: AllRecipeReceiver.result.imageURLs[index],
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Container(
                              width: 215,
                              margin: const EdgeInsets.only(left: 20),
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
      ),
    );

      // ListView(
  }
}

