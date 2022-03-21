import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'BackendService/WebSraper.dart';

class RecipePageInfoReceiver {
  static String recipeURL = "";
  static List<String> basicInfo = [];
  static List<String> ingredients = [];

  getBasicInfo () async {
    basicInfo =  await WebScraper().extractRecipeInfoURL(RecipePageInfoReceiver.recipeURL);
  }

  getIngredients () async {
    ingredients = await WebScraper().extractIngredients(RecipePageInfoReceiver.recipeURL);
  }
}

class RecipePage extends StatefulWidget {

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  @override
  Widget build(BuildContext context) {

    print("========== printing from recipe page ==========");
    // List<String> basicInfo = WebScraper().extractRecipeInfoURL(RecipeURLReceiver.recipeURL);
    // print(RecipeInfoReceiver.result.basicInfo);
    List<String> basicInfo = RecipePageInfoReceiver.basicInfo;
    print(basicInfo);

    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 65,
              child: CircleAvatar(
                backgroundImage: NetworkImage(basicInfo[1]),
                radius: 60,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              basicInfo[0],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontFamily: 'AlfaSlabOne',
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Prep Time: " + basicInfo[2],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'VarelaRound',
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        "Cook Time: " + basicInfo[3],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'VarelaRound',
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        "Additional Time: " + basicInfo[4],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'VarelaRound',
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        "Servicing: " + basicInfo[5],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'VarelaRound',
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        "Yield: " + basicInfo[6],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'VarelaRound',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: const Text(
              "Ingredients",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'VarelaRound',
                decoration: TextDecoration.none,
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(10),
          //   decoration: const BoxDecoration(
          //     color: Colors.white54,
          //     borderRadius: BorderRadius.all(Radius.circular(10)),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.grey,
          //         offset: Offset(0, 3),
          //       ),
          //     ],
          //   ),
          // ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: RecipePageInfoReceiver.ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 100,
                  // margin: const EdgeInsets.all(15.0),
                  // padding: const EdgeInsets.all(3.0),
                  child: Text(
                    RecipePageInfoReceiver.ingredients[index],
                    style: const TextStyle(
                      fontFamily: 'VarelaRound',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
  }
}

