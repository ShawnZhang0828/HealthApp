import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:health_app/search_result_page.dart';
import 'BackendService/WebSraper.dart';
import 'BackendService/SetPreference.dart';
import 'package:url_launcher/url_launcher.dart';

class FavButton extends StatefulWidget {

  bool inFav = false;
  String recipeName = RecipePageInfoReceiver.basicInfo[0];
  List<String> favList = [];

  _init () async {
    favList = await PreferenceSetter.readString("favorite");
    inFav = favList.contains(recipeName);
  }

  @override
  _FavButtonState createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {

  @override
  void initState() {
    super.initState();
    _read(); // read in initState
  }

  _read() async {
    List<String> favList = await PreferenceSetter.readStringList("favorite");
    List<String> recipeInfoList = [
      RecipePageInfoReceiver.basicInfo[0],
      RecipePageInfoReceiver.basicInfo[1],
      RecipePageInfoReceiver.recipeURL
    ];
    String recipeInfoString = json.encode(recipeInfoList);
    setState(() {
      widget.inFav = favList.contains(recipeInfoString);
    });
  }

  @override
  Widget build(BuildContext context) {

    return widget.inFav
      ? IconButton(
      onPressed: () async {
        List<String> recipeInfoList = [
          RecipePageInfoReceiver.basicInfo[0],
          RecipePageInfoReceiver.basicInfo[1],
          RecipePageInfoReceiver.recipeURL
        ];
        String recipeInfoString = json.encode(recipeInfoList);
        List<String> favList = await PreferenceSetter.readStringList("favorite");
        favList.remove(recipeInfoString);
        PreferenceSetter.writeList("favorite", favList);
        setState(() {
          widget.inFav = favList.contains(recipeInfoString);
        });
      },
      icon: const Icon(
        Icons.favorite,
        size: 32,
        // TODO
        // color: Color(0xff367349),
      ),
    ) : IconButton(
      onPressed: () async {
        List<String> recipeInfoList = [
          RecipePageInfoReceiver.basicInfo[0],
          RecipePageInfoReceiver.basicInfo[1],
          RecipePageInfoReceiver.recipeURL
        ];
        String recipeInfoString = json.encode(recipeInfoList);
        List<String> favList = await PreferenceSetter.readStringList("favorite");
        favList.add(recipeInfoString);
        PreferenceSetter.writeList("favorite", favList);
        setState(() {
          widget.inFav = favList.contains(recipeInfoString);
        });
        print(favList);
      },
      icon: Icon(
        Icons.favorite_border,
        size: Theme.of(context).iconTheme.size,
        // TODO
        color: Theme.of(context).iconTheme.color,
        // color: Color(0xff367349),
      ),
    );
  }
}

class RecipePageInfoReceiver {
  static String recipeURL = "";
  static List<String> basicInfo = ["N/A"];
  static List<String> ingredients = ["N/A"];
  static List<String> directions = ["N/A"];
  static List<String> nutritionFacts = ["N/A"];

  getBasicInfo () async {
    basicInfo =  await WebScraper().extractRecipeInfoURL(RecipePageInfoReceiver.recipeURL);
  }

  getIngredients () async {
    ingredients = await WebScraper().extractIngredients(RecipePageInfoReceiver.recipeURL);
  }

  getDirections() async {
    directions = await WebScraper().extractDirections(RecipePageInfoReceiver.recipeURL);
  }

  getNutritionFacts() async {
    nutritionFacts = await WebScraper().extractNutritionFact(RecipePageInfoReceiver.recipeURL);
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

    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      theme: Theme.of(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            basicInfo[0],
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchResultPage())),
            },
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).secondaryHeaderColor,
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: Container(
          color: Theme.of(context).canvasColor,
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20, top: 15, left: width*0.34),
                    child: CircleAvatar(
                      // TODO
                      backgroundColor: Theme.of(context).backgroundColor,
                      radius: 65,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1.5),
                        child: CachedNetworkImage(
                          alignment: Alignment.center,
                          imageUrl: basicInfo[1],
                          imageBuilder: (context, imageProvider) => Container(
                            width: 123,
                            height: 123,
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
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: width*0.0, bottom: 110),
                    child: FavButton(),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  basicInfo[0],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
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
                      decoration: BoxDecoration(
                        // TODO
                        color: Theme.of(context).canvasColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            // TODO
                            color: Theme.of(context).shadowColor,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Prep Time: " + basicInfo[2],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'VarelaRound',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Cook Time: " + basicInfo[3],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'VarelaRound',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Additional Time: " + basicInfo[4],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'VarelaRound',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Servicing: " + basicInfo[5],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'VarelaRound',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Yield: " + basicInfo[6],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
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
                child: Text(
                  "Ingredients",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 30,
                    fontFamily: 'VarelaRound',
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Column(
                children: [
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: RecipePageInfoReceiver.ingredients.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 300,
                              margin: const EdgeInsets.only(bottom: 3),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: Color(0xff617750)),
                                ),
                              ),
                              child: Text(
                                RecipePageInfoReceiver.ingredients[index],
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(
                  "Directions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 30,
                    fontFamily: 'VarelaRound',
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Column(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: RecipePageInfoReceiver.directions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1, color: Color(0xff617750)),
                              ),
                              // color: Colors.white54,
                              // borderRadius: BorderRadius.all(Radius.circular(10)),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey,
                              //     offset: Offset(0, 3),
                              //   ),
                              // ],
                            ),
                            width: 350,
                            child: Text(
                              "Step " + (index+1).toString() + ": " + RecipePageInfoReceiver.directions[index],
                              textAlign: TextAlign.center,
                              // maxLines: 3,
                              style: const TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5, top: 15),
                child: Text(
                  "Nutrition Overview",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 30,
                    fontFamily: 'VarelaRound',
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    width: 300,
                    child: Text(
                      RecipePageInfoReceiver.nutritionFacts[0].substring(0, RecipePageInfoReceiver.nutritionFacts[0].indexOf("Full Nutrition")),
                      textAlign: TextAlign.center,
                      // maxLines: 3,
                      style: const TextStyle(
                        fontFamily: 'VarelaRound',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 5, top: 10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Source of data: ",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 13,
                          fontFamily: 'VarelaRound',
                          decoration: TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: 'allrecipes',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 13,
                          fontFamily: 'VarelaRound',
                          decoration: TextDecoration.none,
                        ),
                        recognizer: TapGestureRecognizer()..onTap =  () async{
                          try {
                            await launch(
                              RecipePageInfoReceiver.recipeURL,
                              enableJavaScript: true,
                            );
                            return;
                          } catch (e) {
                            print(e.toString());
                            return;
                          }
                          // if (await launch(RecipePageInfoReceiver.recipeURL)) {
                          //   await launch(RecipePageInfoReceiver.recipeURL);
                          // } else {
                          //   throw 'Could not launch $RecipePageInfoReceiver.recipeURL';
                          // }
                        }
                      ),
                    ],
                  ),
                ),
                // child: const Text(
                //   "Source of data: allrecipes",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Color(0xff495b41),
                //     fontSize: 13,
                //     fontFamily: 'VarelaRound',
                //     decoration: TextDecoration.none,
                //   ),
                // ),
              ),
              ],
            ),
        ),
        ),
    );
  }
}

