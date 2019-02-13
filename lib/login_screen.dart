import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_app/auth.dart';
import 'package:flutter_list_app/common/loading_indicator.dart';

enum FormMode { LOGIN, SIGNUP }


class LoginScreen extends StatefulWidget {
  LoginScreen({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final Function onSignedIn;
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;
  String _email;
  String _password;
  FormMode _formMode = FormMode.LOGIN;
  String _errorMessage;
  final passKey = GlobalKey<FormFieldState>();




  Container LoginButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      width: 200,
      child: RaisedButton(
          onPressed: _validateAndSubmit,
          child: _formMode == FormMode.LOGIN
              ?  Text('Login')
              :  Text('Create account'),
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: _formMode == FormMode.LOGIN ? Text('Login'): Text('SinUp')),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'http://autodoktor.com.ua/wp-content/uploads/Logo/Total-logo-earth.png',
                          width: 200,
                          height:  _formMode == FormMode.LOGIN ? 200 : 150,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                          onSaved: (value) => _email = value,
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          key: passKey,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                color: _obscureText
                                    ? Colors.black38
                                    : Colors.blue[400],
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              )),
                          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                          onSaved: (value) => _password = value,
                          obscureText: _obscureText,
                        ),
                        _formMode == FormMode.LOGIN
                            ? SizedBox(height: 0,) :
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              suffixIcon: IconButton(
                                color: _obscureText
                                    ? Colors.black38
                                    : Colors.blue[400],
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              )),
                          validator: (value) => value != passKey.currentState.value ? 'Password don\'t match' : null,
                          obscureText: _obscureText,
                        ),
                        isLoading
                            ? Container(
                            padding:
                            EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 12),
                            child: LoadingIndicator())
                            : LoginButton(),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            children: <Widget>[
                              _formMode == FormMode.LOGIN ?
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RaisedButton(
                                      child: Text('Sign in with Google'),
                                      elevation: 4.0,
                                      color: Colors.white,
                                      textColor: Colors.black54,
                                      splashColor: Colors.white12,
                                      onPressed: signInGoogle,
                                    ),
                                    RaisedButton(
                                      child: Text('Sign in with Facebook'),
                                      elevation: 4.0,
                                      color: Color.fromRGBO(59, 89, 152, 1),
                                      textColor: Colors.white,
                                      splashColor: Color.fromRGBO(59, 89, 152, 1),
                                      onPressed: signInFacebook,
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox(height: 0,),
                              Container(
                                  height: 35,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _formMode == FormMode.LOGIN
                                          ? Text("Don't have an account?")
                                          : Text('Have an account?'),
                                      Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: FlatButton(
                                            child: _formMode == FormMode.LOGIN
                                                ?  Text('Create an account')
                                                :  Text('Sign in'),
                                            textColor: Colors.blue,
                                            onPressed: _formMode == FormMode.LOGIN
                                                ? _changeFormToSignUp
                                                : _changeFormToLogin,
                                          ))
                                    ],
                                  )),
                              showErrorMessage()
                            ],
                          ),
                        )
                      ],
                    )))));
  }
  @override
  void initState() {
    _errorMessage = "";
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
    });
    if (_validateAndSave()) {
      isLoading = true;
      var userId ;
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
        }
        if (userId.length > 0 && userId != null) {
          widget.onSignedIn('email');
        }
        isLoading = false;
      } catch (e) {
        isLoading = false;
        setState(() {
          _errorMessage = e.message;
        });
        print('Error: $e');

      }
    }
  }

  signInGoogle() async {
    var userId = await widget.auth.signInWithGoogle();

    if (userId != null) {
      widget.onSignedIn('google');
    }
  }

  signInFacebook() async {
    var userId = await widget.auth.signInWithFacebook();

    if (userId != null) {
      widget.onSignedIn('facebook');
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
