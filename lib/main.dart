// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'BackendService/ColorTheme.dart';
import 'BackendService/SetPreference.dart';
import 'login_page.dart';
import 'sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => MyApp()));
}

class MyApp extends StatefulWidget {

  String colorTheme = "";
  List<String> fav = [];
  String target_plan = "";
  String dark_mode = "";
  String font_size = "";
  String language = "";

  _init () async {
    colorTheme = await PreferenceSetter.readString("Dark_Mode");
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    _read(); // read in initState
  }

  _read() async {
    String colorTheme = await PreferenceSetter.readString("Dark_Mode");

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      widget.colorTheme = colorTheme;
    });

    widget.fav = await PreferenceSetter.readStringList("favorite");
    widget.target_plan = await PreferenceSetter.readString("Target_Plan");
    widget.font_size = await PreferenceSetter.readString("Font_Size");
    widget.language = await PreferenceSetter.readString("Language");
    if (widget.fav == null) {
      PreferenceSetter.writeList("favorite", []);
    }
    if (widget.target_plan == null) {
      PreferenceSetter.writeString("Target_Plan", "Default Plan");
    }
    if (widget.font_size == null) {
      PreferenceSetter.writeString("Font_Size", "Medium");
    }
    if (widget.language == null) {
      PreferenceSetter.writeString("Language", "English");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("dark mode: " + widget.colorTheme);
    // widget.colorTheme ??= "Off";
    return MaterialApp(
      title: 'Health App',
      theme: widget.colorTheme == "On" ? ThemeClass.darkTheme : ThemeClass.lightTheme,
      home: LoginPage(),
    );
  }
}