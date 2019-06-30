import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './auth/root_page.dart';
import './auth/auth.dart';
import './auth/login.dart';
import './pages/home.dart';
import './pages/all_chats.dart';
import './screens/phone_auth.dart';

void main() => runApp(MyApp());

String userId;
String thePatient;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    _getUserId();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(
        auth: Auth(),
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginSignUpPage(),
        '/home': (BuildContext context) => Home(Auth(), signedIn(), userId),
      },
    );
  }

  signedIn() {}

  void _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
  }
}
