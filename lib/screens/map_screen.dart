import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Nearby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Direction"),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 1,
            child: ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                title: Text("Cancer clinic"),
                onTap: () {
                  _openMap(
                      "cancer+treatment+centre+Kenyatta+Hospital,+Nairobi");
                }),
          ),
          Card(
            elevation: 1,
            child: ListTile(
                leading: Icon(
                  Icons.directions,
                  color: Colors.red,
                ),
                title: Text("ENT"),
                onTap: () {
                  _openMap("ENT+Kenyatta+Hospital, +Nairobi");
                }),
          ),
          Card(
            elevation: 1,
            child: ListTile(
                leading: Icon(
                  Icons.directions,
                  color: Colors.red,
                ),
                title: Text("Diabetes"),
                onTap: () {
                  _openMap("Diabetic+Clinic+kenyatta+Hospital, +Nairobi+City");
                }),
          ),
        ],
      ),
    );
  }
}



_openMap(String clinic) async {
  // Android
//  var url = 'geo:52.32,4.917';
  var url = 'google.navigation:q=' + clinic;
  if (Platform.isIOS) {
    // iOS
//    url = 'http://maps.apple.com/?ll=52.32,4.917';
    url =
        'https://www.google.com/maps?daddr=cancer+treatment+centre+Kenyatta+Hospital,+Nairobi&dir_action=navigate';
  }
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//void _launchMapsUrl() async {
//  final url = 'https://www.google.com/maps?daddr=cancer+treatment+centre+Kenyatta+Hospital,+Nairobi&dir_action=navigate';
//  if (await canLaunch(url)) {
//    await launch(url);
//  } else {
//    throw 'Could not launch $url';
//  }
//}

//listofclinics.add(
//new ClinicList(
//"Cancer Treatment Center",
//"cancer+treatment+centre+Kenyatta+Hospital,+Nairobi",
//"30",
//"4"));
//listofclinics.add(
//new ClinicList(
//"ENT",
//"ENT+Kenyatta+Hospital, +Nairobi",
//"30",
//"43"));
//listofclinics.add(
//new ClinicList(
//"Diabetes",
//"Diabetic+Clinic+kenyatta+Hospital, +Nairobi+City",
//"20",
//"34"));
//listofclinics.add(
//new ClinicList(
//"Renal",
//"Renal+Unit+kenyatta+Hospital,+Nairobi",
//"20",
//"43"));

//waze
//canLaunch("waze://")
//launch("waze://?ll=${latitude},${longitude}&navigate=yes");
////gmaps
//canLaunch("comgooglemaps://")
//launch("comgooglemaps://?saddr=${latitude},${longitude}&directionsmode=driving")
