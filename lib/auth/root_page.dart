import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';
import 'login.dart';
import '../pages/home.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final Auth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, SignedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  String userId;

  void _signedIn() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
      _authStatus = AuthStatus.SignedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.SignedIn;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserId();
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return LoginSignUpPage(
          auth: Auth(),
          onSignedIn: _signedIn,
        );
      case AuthStatus.SignedIn:
        return Home(Auth(), _signedOut, userId);
    }
  }

  void _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
  }
}
