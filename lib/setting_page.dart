import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BackendService/SetPreference.dart';
import 'login_page.dart';
import 'main_page.dart';
import 'main.dart';

class DropDownMenu extends StatefulWidget {

  List<String> items;
  String dropDownValue = "";
  String settingName;

  DropDownMenu(this.items, this.settingName) {
    dropDownValue = items[0];
  }

  _init () async {
    dropDownValue = await PreferenceSetter.readString(settingName);
  }

  @override
  _DropDownMenuState createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {

  @override
  void initState() {
    super.initState();
    _read(); // read in initState
  }

  _read() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.dropDownValue = prefs.getString(widget.settingName) ?? widget.items[0]; // get the value
    });
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Changing Color Theme Reminder"),
          content: Text("Restart the app to finish up changing the color theme !"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: Theme.of(context).colorScheme == const ColorScheme.light() ? ThemeData.light() : ThemeData.dark(),
      child: DropdownButton(
        value: widget.dropDownValue,
        icon: const Icon(Icons.arrow_downward),
        underline: Container(
          height: 2,
          color: const Color(0xff71c1aa),
        ),
        isExpanded: false,
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            widget.dropDownValue = newValue!;
            PreferenceSetter.writeString(widget.settingName, newValue);
          });
          if (widget.settingName == "Dark_Mode") {
            createAlertDialog(context);
          }
        },
      ),
    );
  }
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {

    double pageWidth = MediaQuery.of(context).size.width;
    double leftWidth = pageWidth * 0.4;
    double rightWidth = pageWidth - leftWidth;

    const separator = SizedBox(
      height: 40,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
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
      body: Row(
        children: [
          Container(
            width: leftWidth,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Color(0xff71c1aa),
                  width: 2,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 40),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xff71c1aa),
                    radius: 42,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                      child: Image.asset('assets/images/logo3.png'),
                      radius: 40,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  title: Text(
                    "General",
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_box,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  title: Text(
                    "Account",
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  title: Text(
                    "Personalization",
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  title: Text(
                    "LogOut",
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () => {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()))
                  },
                ),
              ],
            ),
          ),
          Container(
            width: rightWidth,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    "General",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Language",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                      child: DropDownMenu(const ["English", "French", "Chinese", "German", "Italian", "Japanese"], "Language")
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Font Size",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: DropDownMenu(const ["Medium", "Small", "Large"], "Font_Size")
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: DropDownMenu(const ["Off", "On"], "Dark_Mode")
                    ),
                  ],
                ),
                separator,
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: TextButton(
                      style: Theme.of(context).textButtonTheme.style,
                      onPressed: () => {},
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                separator,
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    "Personalization",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    "Target Plan",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: DropDownMenu(const ["Default Plan", "Weight Loss", "Muscle Gain", "Calcium Supplement"], "Target_Plan")
                  ),
                ),
                separator,
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.warning_amber,
                            size: 17,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                        TextSpan(
                          text: "\t Please follow doctor's advice if you have any special health conditions.",
                          style:  TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                separator,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
