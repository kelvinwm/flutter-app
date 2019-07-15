import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

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
import '../screens/previous_appointments.dart';

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

final recentJobsRef = FirebaseDatabase.instance
    .reference()
    .child('availableclinics')
    .child("Patients");

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

  void _prevAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PreviousAppointments(userId)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Bookings"),
      ),
      body: StreamBuilder(
        stream: recentJobsRef
            .child('${widget.userId}')
            .orderByChild('timestamp')
            .onValue,
        builder: (context, snap) {
          if (snap.hasError) {
            return Container(
              child: Center(
                child: Icon(Icons.mood_bad),
              ),
            );
          }
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snap.data.snapshot.value == null) {
                return Container(
                  child: Center(
                    child: Icon(Icons.mood_bad),
                  ),
                );
              }
              List<Item> myItem = [];
              var ref = snap.data.snapshot.value;
              var keys = ref.keys;
              for (var key in keys) {
                if (!(ref[key]["status"].toString().contains("Attended"))) {
                  Item items = new Item(
                    ref[key]["clinicdate"],
                    ref[key]["clinicname"],
                    ref[key]["clinictime"],
                    ref[key]["keytouse"],
                    ref[key]["status"],
                    ref[key]["timestamp"],
                  );
                  myItem.add(items);
                }
              }

              return incomingMessage(myItem, context);
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
              leading: Icon(Icons.visibility),
              title: Text('Previous Appointments'),
              onTap: () {
                // Update the state of the app.
                Navigator.pop(context);
                _prevAppointments();
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
                        builder: (BuildContext context) =>
                            PatientId(widget.userId)));
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

//  void _getUserId() async {
//    final prefs = await SharedPreferences.getInstance();
//    myUserId = prefs.getString('userId') ?? '';
//  }
}

Widget incomingMessage(List<Item> res, BuildContext context) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: res.length,
    itemBuilder: (context, index) {
      res.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      res.reversed;
//      if (!(res[index].status.contains("Attended"))) {
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
                        Text(res[index].clinicname,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                          child: Text('Date:      ' + res[index].clinicdate),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                          child: Text('Time:     ' + res[index].clinictime),
                        ),
                        Text('Status:   ' + res[index].status),
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
                            res[index].clinicname,
                            "YES",
                            res[index].keytouse)));
              },
            )),
      );
//      }
    },
  );
}

showAlertDialog(BuildContext context) async {
  // set up the buttons
  final prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('userId') ?? '';

  Widget cancelButton = FlatButton(
    child: Text("No proceed"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => NewPatient(userId)));
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

class Item {
  String clinicdate, clinicname, clinictime, keytouse, status, timestamp;

  Item(
    this.clinicdate,
    this.clinicname,
    this.clinictime,
    this.keytouse,
    this.status,
    this.timestamp,
  );
}
