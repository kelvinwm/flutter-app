import 'package:flutter/material.dart';
import 'detailed_service_charter.dart';

class ServiceCharter extends StatefulWidget {
  @override
  _ServiceCharterState createState() => _ServiceCharterState();
}

class _ServiceCharterState extends State<ServiceCharter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service Charter"),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 2,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DetailedCharter()));
              },
              title: Text(
                "Registration for outpatient",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.2,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Client requirement:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textScaleFactor: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "1. Observation Sheet",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textScaleFactor: 1.2,
                  ),
                  Text(
                    "2. Payment for consultation",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textScaleFactor: 1.2,
                  ),
                  Text(
                    "3. National ID/Passport",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textScaleFactor: 1.2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "View payment details",
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                    textScaleFactor: 1.2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 2,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DetailedCharter()));
              },
              title: Text(
                "Admission of patients",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.2,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Client requirement:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textScaleFactor: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "1. Doctors recommendation for admission",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textScaleFactor: 1.2,
                  ),
                  Text(
                    "2. Payment for file and payment of deposit",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textScaleFactor: 1.2,
                  ),
                  Text(
                    "3. National ID/Passport",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textScaleFactor: 1.2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "View payment details",
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                    textScaleFactor: 1.2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
//              Text("Client requirement:\n" +
//                  " 1.Doctors recommendation for admission\n " +
//                  "2. Payment for file and payment of deposit \n " +
//                  "3. National ID/ passport\n")
              ,
            ),
          ),
        ],
      ),
    );
  }
}
