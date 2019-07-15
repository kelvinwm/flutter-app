import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PreviousAppointments extends StatefulWidget {
  PreviousAppointments(this.userId);

  final String userId;

  @override
  _PreviousAppointmentsState createState() => _PreviousAppointmentsState();
}

final recentJobsRef = FirebaseDatabase.instance
    .reference()
    .child('availableclinics')
    .child("Patients");

class _PreviousAppointmentsState extends State<PreviousAppointments> {
  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Previous Appointments"),
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
                if (ref[key]["status"].toString().contains("Attended")) {
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
    );
  }

  Widget incomingMessage(List<Item> res, BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: res.length,
      itemBuilder: (context, index) {
        res.sort((a, b) => a.timestamp.compareTo(b.timestamp));
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
          ),
        );
      },
    );
  }
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
