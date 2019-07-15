import 'package:flutter/material.dart';

class DetailedCharter extends StatefulWidget {
  @override
  _DetailedCharterState createState() => _DetailedCharterState();
}

class _DetailedCharterState extends State<DetailedCharter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Details"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  "SERVICE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1,
                )),
                Expanded(
                    child: Text(
                  "GENERAL COST",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1,
                )),
                Expanded(
                    child: Text(
                  "PRIVATE COST",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1,
                )),
                Expanded(
                    child: Text(
                  "WAITING TIME",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1,
                )),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(2),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("File opening (Outpatient)")),
                  Expanded(child: Text("Ksh.600")),
                  Expanded(child: Text("N/A")),
                  Expanded(
                      child:
                          Text("Emergency: 5 minutes Non-emergency: 1 hour")),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(2),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("File opening (Admission of patient)")),
                  Expanded(child: Text("Ksh.300")),
                  Expanded(child: Text("N/A")),
                  Expanded(
                      child:
                          Text("Emergency: 5 minutes Non-emergency: 1 hour")),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(2),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text("Medical services (Admission of patient)")),
                  Expanded(child: Text("Ksh.8,000")),
                  Expanded(child: Text("N/A")),
                  Expanded(
                      child:
                          Text("Emergency:Immediate Non-emergency: 3 hours")),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(2),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text("Surgical Services (Admission of patient)")),
                  Expanded(child: Text("Ksh.20,000")),
                  Expanded(child: Text("N/A")),
                  Expanded(
                      child: Text("Emergency:Immediate Non-emergency:3 hour")),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(2),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                          "Critical care services (Admission of patient)")),
                  Expanded(child: Text("Ksh.100,000")),
                  Expanded(child: Text("N/A")),
                  Expanded(child: Text("Depends on Availability of bed")),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(2),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("Test For Malaria Parasites")),
                  Expanded(child: Text("Ksh.100")),
                  Expanded(child: Text("Ksh.300")),
                  Expanded(child: Text("1 hour")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
