import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'BackendService/WebSraper.dart';

class RecipeURLReceiver {
  static String recipeURL = "";
  static List<String> basicInfo = [];

  getBasicInfo () async {
    basicInfo =  await WebScraper().extractRecipeInfoURL(RecipeURLReceiver.recipeURL);
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
    List<String> basicInfo = RecipeURLReceiver.basicInfo;
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
    );

  }
}

