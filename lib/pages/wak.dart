//import 'package:flutter/material.dart';
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new MyHomePage(title: 'Where the heart is'),
//      onGenerateRoute: _getRoute,
//    );
//  }
//
//  Route _getRoute(RouteSettings settings) {
//    switch (settings.name){
//      case '/edit':
//        return _buildRoute(settings, new Editor());
//      case '/use':
//        return _buildRoute(settings, new Use());
//      default:
//        return null;
//    }
//  }
//  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder){
//    return new MaterialPageRoute(
//      settings: settings,
//      builder: (BuildContext context) => builder,
//    );
//  }
//}