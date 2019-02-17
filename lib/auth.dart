import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<String> signInWithGoogle();

  Future<String> signInWithFacebook();

  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .setData({'email': user.email, 'uid': user.uid});
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<String> signInWithGoogle() async {
    GoogleSignInAccount gSAccount = await GoogleSignIn().signIn();
    if (gSAccount != null) {
      GoogleSignInAuthentication gSAuthentication =
          await gSAccount.authentication;
      final AuthCredential credential = await GoogleAuthProvider.getCredential(
          idToken: gSAuthentication.idToken,
          accessToken: gSAuthentication.accessToken);
      FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
      return user.uid;
    } else {
      return null;
    }
  }

  Future<String> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final FacebookLoginResult result =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        FirebaseUser user =
            await _firebaseAuth.signInWithCredential(credential);

        return user.uid;
        break;
      case FacebookLoginStatus.cancelledByUser:
        return null;
        break;
      case FacebookLoginStatus.error:
        return null;
        break;
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String signInFrom = prefs.getString("SignInFrom");
    switch (signInFrom) {
      case 'email':
        return _firebaseAuth.signOut();
        break;
      case 'google':
        await GoogleSignIn().signOut();
        return _firebaseAuth.signOut();
        break;
      case 'facebook':
        await FacebookLogin().logOut();
        return _firebaseAuth.signOut();
        break;
    }
  }
}
