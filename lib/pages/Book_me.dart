import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/auth.dart';

//TODO: SHOW TIME AND DATE
class BookNew extends StatefulWidget {
  final String userClinic;
  final String isSchedule;
  final String pKey;

  BookNew(this.userClinic, this.isSchedule, this.pKey);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookNewState(userClinic);
  }
}

class _BookNewState extends State<BookNew> {
  final String userClinic;

  _BookNewState(this.userClinic);

  var now = new DateTime.now();
  int newDate = 0;

  String theDate = DateFormat('MMMMEEEEd').format(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text("Choose Clinic Date and Time"),
            Text("$userClinic")
          ],
        ),
      ),
      body: Container(
        margin: new EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
                leading: IconButton(
                  icon: new Icon(Icons.skip_previous),
                  onPressed: () {
                    /* Prev date */
                    setState(() => {
                          if (!(newDate < 1))
                            {
                              newDate -= 1,
                              theDate = DateFormat('MMMMEEEEd').format(DateTime(
                                  now.year, now.month, now.day + newDate)),
                            }
                        });
                  },
                ),
                title: Center(child: Text(theDate)),
                trailing: IconButton(
                  icon: new Icon(Icons.skip_next),
                  onPressed: () {
                    /* Next date */
                    setState(() => {
                          newDate += 1,
                          theDate = DateFormat('MMMMEEEEd').format(
                              DateTime(now.year, now.month, now.day + newDate)),
                        });
                  },
                )),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                onTap: () {
                  _getBookingTime('Morning to Mid-Morining');
                },
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Morning to Mid-Morining",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1.2,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Available",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                onTap: () {
                  _getBookingTime('Afternoon to Evening');
                },
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Afternoon to Evening",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1.2,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Available",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1.2,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getBookingTime(String timePeriod) async {
    final prefs = await SharedPreferences.getInstance();
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        final userId = prefs.getString('userId') ?? '';
        final pID = prefs.getString('patient_id') ?? '';
        final pName = prefs.getString('p_names') ?? '';
        final pAge = prefs.getString('p_age') ?? '';
        final phone = prefs.getString('p_phone') ?? '';

        try {
          if (widget.isSchedule.trim() == "YES") {
            Firestore.instance
                .collection('bookings')
                .document("$userId")
                .collection("$userId")
                .document(widget.pKey)
                .updateData({'date': '$theDate', 'time': '$timePeriod'});
          } else {
            Firestore.instance
                .collection('bookings')
                .document("$userId")
                .collection("$userId")
                .document()
                .setData({
              'clinic': '${widget.userClinic}',
              'date': '$theDate',
              'time': '$timePeriod',
              'name': '$pName',
              'age': '$pAge',
              'patientID': '$pID',
              'phone': '$phone',
              'status': 'pending',
            });
          }

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        } catch (e) {
          print(e);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
//    backgroundColor: Colors.blueGrey,
      title: Text("Book Clinic"),
      content: Text("Would you like to book $userClinic $theDate ?"),
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
}
