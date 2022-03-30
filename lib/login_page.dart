import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_app/sign_up.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return user;
  }
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    
    final logo = Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 70),
      child: Hero(
          tag: 'hero',
          child: CircleAvatar(
            backgroundColor:Theme.of(context).canvasColor,
            // backgroundColor: Colors.white,
            radius: 56.0,
            child: Image.asset('assets/images/title_icon.png'),
          )
      ),
    );
    final inputEmail = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0)
          ),
          fillColor: Theme.of(context).primaryColor,
          filled: true,
        ),
      ),
    );
    final inputPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0)
          ),
          fillColor: Theme.of(context).primaryColor,
          filled: true,
        ),
      ),
    );
    final buttonLogin = Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        // buttonColor: Theme.of(context).buttonTheme
        child: ElevatedButton(
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () => {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()))
          },
        ),
      ),
    );
    final buttonForgotPassword = FlatButton(
        padding: const EdgeInsets.only(top: 35),
        child: Text(
          'Forgot Password',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onPressed: null
    );
    final buttonSigninGoogle = FloatingActionButton.extended(
      onPressed: () async {
        setState(() {
          _isSigningIn = true;
        });

        User? user =
        await Authentication.signInWithGoogle(context: context);

        setState(() {
          _isSigningIn = false;
        });

        if (user != null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
        }
      },
        label: Text(
          'Sign in with Google',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        icon: Image.asset(
            'assets/images/Google-icon.png',
            height: 32,
            width: 32,
        ),
        backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        foregroundColor: Colors.white,
      );
    final buttonSignUp = FlatButton(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'Sign Up',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      onPressed: () => {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()))
      },
    );
    return SafeArea(
        child: Scaffold(
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: <Widget>[
              logo,
              inputEmail,
              inputPassword,
              buttonLogin,
              SizedBox(
                height: 10,
              ),
              buttonSigninGoogle,
              buttonForgotPassword,
              buttonSignUp,
            ],
          ),
        )
    );
  }
}