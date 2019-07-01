import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth.dart';
import 'consult_specialist.dart';
import 'Book_me.dart';
import 'new_patient_details.dart';
import 'all_chats.dart';
import '../screens/map_screen.dart';
import '../screens/patient_id.dart';
import '../screens/service_charter.dart';
import '../screens/campaigns.dart';
import '../screens/health_tips.dart';
import '../auth/root_page.dart';

class Home extends StatefulWidget {
  Home(this.auth, this.onSignedOut, this.userId);

  final Auth auth;
  final VoidCallback onSignedOut;
  String userId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomepageState();
  }
}

class HomepageState extends State<Home> {
  String myUserId;

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  void _allChats() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AllChats(userId)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("My Bookings"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('bookings')
            .document("${widget.userId}")
            .collection("${widget.userId}")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return Column(
                children: <Widget>[
                  incomingMessage(snapshot, context),
                ],
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAlertDialog(context);
        },
        tooltip: "oops",
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: ListTile.divideTiles(context: context, tiles: [
            DrawerHeader(
              child: Image.asset('assets/knh.png'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              dense: true,
              onTap: () {
                // Update the state of the app.
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Book  Clinic'),
              onTap: () {
                // Update the state of the app.
                Navigator.pop(context);
                showAlertDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.forum),
              title: Text('Consult Specialist'),
              onTap: () {
                // Update the state of the app.
                // Then close the drawer
                Navigator.pop(context);
                _allChats();
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Acquire patient ID'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PatientId()));
              },
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Service Charter'),
              onTap: () {
                // Update the state of the app.
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ServiceCharter()));
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Find Clinic Direction'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Nearby()));
              },
            ),
            ListTile(
              leading: Icon(Icons.video_call),
              title: Text('Video Chat'),
              onTap: () {
                // Update the state of the app.
                // Then close the drawer
                Navigator.pop(context);
                _allChats();
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Health Tips'),
              onTap: () {
                // Update the state of the app.
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HealthTips()));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Campaigns'),
              onTap: () {
                // Update the state of the app.
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Campaigns()));
              },
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ]).toList(),
        ),
      ),
    );
  }

  void _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getString('userId') ?? '';
  }
}

Widget incomingMessage(
    AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
  return Expanded(
    child: ListView(
      children: snapshot.data.documents.map((DocumentSnapshot document) {
        return Card(
          elevation: 4,
          //  titles[index]     <-- Card widget
          child: ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        // align the text to the left instead of centered
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(document['clinic'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                            child: Text('Date:      ' + document['date']),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                            child: Text('Time:     ' + document['time']),
                          ),
                          Text('Status:   ' + document['status']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: new Icon(Icons.edit),
                onPressed: () {
//                  print('HAPA ${document.documentID}'); // doc id
//                  /* Your code */
//                  print(document['time']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => BookNew(
                              document['clinic'], "YES", document.documentID)));
                },
              )),
        );
      }).toList(),
    ),
  );
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("No proceed"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => NewPatient()));
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Yes consult"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ConsultSpecialist()));
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
//    backgroundColor: Colors.blueGrey,
    title: Text("Book Clinic"),
    content:
        Text("Would you like to consult a specialist before booking a clinic?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
