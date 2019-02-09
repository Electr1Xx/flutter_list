import 'package:flutter/material.dart';
import 'package:flutter_list_app/auth.dart';
import 'package:flutter_list_app/home_page.dart';
import 'package:flutter_list_app/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthPage extends StatefulWidget {
  AuthPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() =>  AuthPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AuthPageState extends State<AuthPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void  _onLoggedIn(typeSignIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.auth.getCurrentUser().then((user){
      prefs.setString("Email", user.email);
      prefs.setString("SignInFrom", typeSignIn);
      prefs.setBool("isLogin", true);
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;

    });
  }

  void _onSignedOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("Email");
    pref.remove("SignInFrom");
    pref.setBool("isLogin", false);
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return  LoginScreen(
          auth: widget.auth,
          onSignedIn: _onLoggedIn
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return  HomePage(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        } else return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}