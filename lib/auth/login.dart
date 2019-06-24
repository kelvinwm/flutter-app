import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});

  final Auth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

enum FormType { login, register }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  String _email, _phone, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  bool _progressBarActive = false;
  bool _textError = false;

  void moveToSignIn() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  //TODO: SIGN IN AND SIGN UP METHOD
  void _loginSignUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      // TODO: Login
      formState.save();
      try {
        String userId;
        setState(() {
          _progressBarActive = true;
        });
        if (_formType == FormType.login) {
          userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
        } else {
          userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
        }
        _getUserUid(userId);
        widget.onSignedIn();
      } catch (e) {
        print(e.message);
        setState(() {
          _textError = true;
          _progressBarActive = false;
        });
      }
    }
  }


  void _getUserUid(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

// TODO progress bar
  Widget _showProgress() {
    return Center(
      child: _progressBarActive == true
          ? CircularProgressIndicator()
          : Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(),
            ),
    );
  }

  // TODO progress bar
  Widget _showError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child:  _textError == true ? Text(
          "Wrong password or email",
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
          textScaleFactor: 1.2,
        ) : Container(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome login"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPhoneInput(),
              _showPasswordInput(),
              _showProgress(),
              _showError(),
              _showLoginButton(),
              _showForgotPassword(),
              _showSignIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showLogo() {
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPhoneInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Phone number',
            icon: Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _phone = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showLoginButton() {
    if (_formType == FormType.login) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.blueAccent,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              _loginSignUp();
            },
            child: Text(
              "Login",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.blueAccent,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              _loginSignUp();
            },
            child: Text(
              "Create an Account",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  Widget _showForgotPassword() {
    if (_formType == FormType.register) {
      return Text("");
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: GestureDetector(
          child: Text("Forgot password",
              textScaleFactor: 1.2,
              style: TextStyle(
                  //                              decoration: TextDecoration.lineThrough,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue)),
          onTap: () {
            // do what you need to do when "Click here" gets clicked
//          print(
//            myEmail.text + " " + myPassword.text,
//          );
          },
        ),
      ),
    );
  }

  Widget _showSignIn() {
    if (_formType == FormType.login) {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: GestureDetector(
              child: Text("Create account!",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                      //                              decoration: TextDecoration.lineThrough,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue)),
              onTap: () {
                moveToSignIn();
              }),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: GestureDetector(
              child: Text("Have an account? Login!",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                      //                              decoration: TextDecoration.lineThrough,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue)),
              onTap: () {
                moveToLogin();
              }),
        ),
      );
    }
  }
}

void _validateAndSubmit() {}
