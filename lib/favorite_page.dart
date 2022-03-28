import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:health_app/recipe_page.dart';
import 'BackendService/WebSraper.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'main_page.dart';

class FavRecipeReceiver {
  static List<String> RecipeInfoList = [];
}

class RecipeInfoDataPasser {
  static SearchResult result = SearchResult();
}

class FavoritePage extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<FavoritePage> {

  @override
  Widget build(BuildContext context) {

    print("============ printing from search result outter ============");
    print(FavRecipeReceiver.RecipeInfoList);
    // print(RecipeInfoDataPasser.result.basicInfo);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Results"),
        backgroundColor: const Color(0xff71c1aa),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage())),
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(207, 202, 209, 100),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: FavRecipeReceiver.RecipeInfoList.length,
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
                        elevation: MaterialStateProperty.all(20),
                        maximumSize: MaterialStateProperty.all(const Size(240, 40)),
                      ),
                      onPressed: () async {
                        RecipePageInfoReceiver.recipeURL = json.decode(FavRecipeReceiver.RecipeInfoList[index])[2];
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
                              imageUrl: json.decode(FavRecipeReceiver.RecipeInfoList[index])[1],
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
                            width: 235,
                            margin: const EdgeInsets.only(left: 30),
                            child: Text(
                              json.decode(FavRecipeReceiver.RecipeInfoList[index])[0],
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

