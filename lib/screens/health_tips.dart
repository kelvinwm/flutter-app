import 'package:flutter/material.dart';

class HealthTips extends StatefulWidget {
  @override
  _HealthTipsState createState() => _HealthTipsState();
}

class _HealthTipsState extends State<HealthTips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Tips"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          Image.asset('assets/campaigns/f1.jpg'),
          Image.asset('assets/campaigns/f2.jpg'),
          Image.asset('assets/campaigns/f3.jpg'),
          Image.asset('assets/campaigns/f4.jpg'),
        ],
      ),
    );
  }
}
