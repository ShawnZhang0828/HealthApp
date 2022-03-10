import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_app/login_page.dart';
import 'dashboard.dart';
import 'main_page.dart';

class IngredientInputPage extends StatefulWidget {
  @override
  _IngredientInputPageState createState() => _IngredientInputPageState();
}
class _IngredientInputPageState extends State<IngredientInputPage> {
  @override
  Widget build(BuildContext context) {
    final ingredientInput = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        onSubmitted: (String str) => {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()))
        },
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0)
          ),
          prefixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              Icons.search,
            ),
          ),
        ),
      ),
    );

    var focusNode = FocusNode();
    RawKeyboardListener(
        focusNode: focusNode,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
          }
        },
        child: ingredientInput,
    );

    return Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: FractionalOffset(0.5, 0.05),
                child: Container(
                  width: 380,
                  height: 50,
                  child: ingredientInput,
                ),
              ),
            ),
          ],
        ),
    );
  }
}