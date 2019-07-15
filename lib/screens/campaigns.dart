import 'package:flutter/material.dart';

class Campaigns extends StatefulWidget {
  @override
  _CampaignsState createState() => _CampaignsState();
}

class _CampaignsState extends State<Campaigns> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Campaigns"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          Image.asset('assets/campaigns/camgn.jpg'),
          Image.asset('assets/campaigns/hiv.jpg'),
          Image.asset('assets/campaigns/chked.jpg'),
          Image.asset('assets/campaigns/agst.jpg'),
        ],
      ),
    );
  }
}
