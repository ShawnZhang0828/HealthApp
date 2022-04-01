//@dart==2.9
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_app/classifier.dart';
import 'package:health_app/classifier_quant.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/search_result_page.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'BackendService/RecipeSort.dart';
import 'BackendService/WebSraper.dart';
import 'BackendService/SetPreference.dart';
import 'main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Classification',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class AllRecipeDataPasser {
  static SearchResult result = SearchResult();
}
enum ButtonState { init, loading, done }
var pred;
var food=pred!.label;
class _MyHomePageState extends State<MyHomePage> {
  late Classifier _classifier;

  var logger = Logger();

  File? _image;
  final picker = ImagePicker();

  Image? _imageWidget;

  img.Image? fox;

  Category? category;

  ButtonState state = ButtonState.init;
  int sortDelay = 20;
  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }

  Future openCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _image = File(pickedFile!.path);
      _imageWidget = Image.file(_image!);

      _predict();
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
      _imageWidget = Image.file(_image!);
      _predict();
    });
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;

    pred = _classifier.predict(imageInput);
    setState(() {
      this.category = pred;
      print(category!.label);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Classification',
            style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage())),
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: _image == null
                ? Container(
                  margin: const EdgeInsets.only(top: 35),
                  child: Text('No image selected.',
                    style: TextStyle(fontSize: 18),),

            )
                : Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: _imageWidget,
            ),
          ),
          SizedBox(
            height: 36,
          ),
          Text(
            category != null ? category!.label :'',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            category != null
                ? 'Confidence: ${category!.score}'
                : '',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      floatingActionButton: Row(
        children: <Widget>[
          const SizedBox(width: 70,),
          FloatingActionButton( // second FAB to perform increment
            onPressed: getImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_photo_alternate_outlined),
          ),
          const SizedBox(width: 70,),
          FloatingActionButton( // second FAB to perform increment
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
            tooltip: 'Pick Image',
            child: Text(
              "Submit",
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 70,),
          FloatingActionButton( // first FAB to perform decrement
            onPressed: openCamera,
            tooltip: 'take picture',
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(height: 80)
        ],
      )
    );
  }

}
