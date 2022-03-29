import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'BackendService/ColorTheme.dart';
import 'BackendService/SetPreference.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  String colorTheme = "";

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

    setState(() {
      widget.colorTheme = colorTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.colorTheme);
    return MaterialApp(
      title: 'Health App',
      theme: widget.colorTheme == "On" ? ThemeClass.darkTheme : ThemeClass.lightTheme,
      home: LoginPage(),
    );
  }
}