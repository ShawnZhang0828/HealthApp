import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'login_page.dart';
import 'main_page.dart';

class DropDownMenu extends StatefulWidget {

  List<String> items = [];
  String dropDownValue = "";

  DropDownMenu(List<String> items) {
    this.items = items;
    dropDownValue = items[0];
  }

  @override
  _DropDownMenuState createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
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
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          widget.dropDownValue = newValue!;
        });
      },
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

    final separator = const SizedBox(
      height: 40,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xff71c1aa),
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
                  leading: const Icon(Icons.settings),
                  title: const Text("General"),
                  onTap: () => null,
                ),
                ListTile(
                  leading: const Icon(Icons.account_box),
                  title: const Text("Account"),
                  onTap: () => null,
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text("Personalization"),
                  onTap: () => null,
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("LogOut"),
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
                  child: const Text(
                    "General",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        "Language",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                      child: DropDownMenu(const ["English", "French", "Chinese", "German", "Italian", "Japanese"])
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        "Font Size",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: DropDownMenu(const ["Medium", "Small", "Large"])
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: DropDownMenu(const ["Off", "On"])
                    ),
                  ],
                ),
                separator,
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        alignment: Alignment.center,
                        backgroundColor: const Color.fromRGBO(127, 191, 164, 100),
                      ),
                      onPressed: () => {},
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                separator,
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: const Text(
                    "Personalization",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  child: const Text(
                    "Target Plan",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: DropDownMenu(const ["Weight Loss", "Muscle Gain", "Calcium Supplement", ])
                  ),
                ),
                separator,
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.warning_amber,
                            size: 17,
                          ),
                        ),
                        TextSpan(
                          text: "\t Please follow doctor's advice if you have any special health conditions.",
                          style:  TextStyle(
                            fontSize: 12,
                            color: Colors.black,
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
