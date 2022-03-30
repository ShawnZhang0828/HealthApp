import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:provider/provider.dart';           // new
import 'BackendService/ColorTheme.dart';
import 'login_page.dart';
import 'login_setting/authentication.dart';
import 'main_page.dart';



class SignUpPage extends StatefulWidget {
  SignUpPage({Key ?key, this.title}) : super(key: key);

  final String? title;
  String colorTheme = "";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    // await FirebaseAuth.instance.signOut();
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> verifyEmail(
      String email,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      var methods =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

}


class _SignUpPageState extends State<SignUpPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.colorTheme == "On" ? ThemeClass.darkTheme : ThemeClass.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Log in/Sign in'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage())),
            },
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: ListView(
          children: <Widget>[
            Consumer<ApplicationState>(
              builder: (context, appState, _) => Authentication(
                email: appState.email,
                loginState: appState.loginState,
                startLoginFlow: appState.startLoginFlow,
                verifyEmail: appState.verifyEmail,
                signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
                cancelRegistration: appState.cancelRegistration,
                registerAccount: appState.registerAccount,
              ),
            ),
            const Divider(
              height: 8,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
  Widget logo() {
    return
      Hero(
          tag: 'hero',
          child: CircleAvatar(
            radius: 56.0,
            child: Image.asset('assets/images/health-logo.png'),
          )
      );
  }
}