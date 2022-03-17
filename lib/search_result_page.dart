import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:health_app/ingrediant_input_page.dart';

class DataReceiver {
  static SearchResult result = SearchResult();
}

class SearchResultPage extends StatefulWidget {

  SearchResultPage() {
    DataPasser.result = SearchResult();
  }

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResultPage> {

  // SearchResult result = DataPasser.result;

  @override
  Widget build(BuildContext context) {

    print("============= printing recipe names from build =============");
    print(DataReceiver.result.recipeNames);

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
                fontFamily: 'LeagueSpartan',
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: DataReceiver.result.recipeNames.length,
              itemBuilder: (context, index) {
                return Container(
                  // alignment: Alignment.center,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)
                  ),
                  // padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 33,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(DataReceiver.result.imageURLs[index]),
                            radius: 30,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Text(
                          DataReceiver.result.recipeNames[index],
                          style: const TextStyle(
                            fontFamily: 'JosefinSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),

                    ],
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

