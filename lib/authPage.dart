import 'package:flutter/material.dart';
import 'package:flutter_list_app/auth.dart';
import 'package:flutter_list_app/home_page.dart';
import 'package:flutter_list_app/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatefulWidget {
  AuthPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => AuthPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AuthPageState extends State<AuthPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  var _user;

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

  void _onLoggedIn(typeSignIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.auth.getCurrentUser().then((firebaseUser) async {
      if (firebaseUser != null) {
        final QuerySnapshot result = await Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: firebaseUser.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          Firestore.instance
              .collection('users')
              .document(firebaseUser.uid)
              .setData({
            'email': firebaseUser.email,
            'photoUrl': firebaseUser.photoUrl ?? '',
            'uid': firebaseUser.uid,
            'name': '',
            'country': null,
            'isAdmin': false
          });

          var currentUser = firebaseUser;
          await prefs.setString('uid', currentUser.uid);
          await prefs.setString('Email', currentUser.email);
          await prefs.setString('photoUrl', currentUser.photoUrl ?? '');
          await prefs.setString('name', currentUser.displayName ?? '');
          await prefs.setString('country', null);
          await prefs.setBool('isAdmin', false);
        } else {
          await prefs.setString('uid', documents[0]['uid']);
          await prefs.setString('Email', documents[0]['email']);
          await prefs.setString('photoUrl', documents[0]['photoUrl']);
          await prefs.setString('name', documents[0]['name']);
          await prefs.setString('country', documents[0]['country']);
          await prefs.setBool('isAdmin', documents[0]['isAdmin']);
        }
      }
      prefs.setString("SignInFrom", typeSignIn);
      setState(() {
        _userId = firebaseUser.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() async {
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
        return LoginScreen(auth: widget.auth, onSignedIn: _onLoggedIn);
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return HomePage(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
