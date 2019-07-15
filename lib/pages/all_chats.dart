import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chats_screen.dart';
import 'consult_specialist.dart';
import 'package:firebase_database/firebase_database.dart';

class AllChats extends StatefulWidget {
  AllChats(this.userId);

  final String userId;

  @override
  _AllChatsState createState() => _AllChatsState();
}

final recentJobsRef =
    FirebaseDatabase.instance.reference().child('Bookclinics').child("Chats");

class _AllChatsState extends State<AllChats> {
  String userName;

  void _myChat(String userName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Chat(widget.userId, userName)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    return WillPopScope(
      onWillPop: () async {
        /// Returning true allows the pop to happen, returning false prevents it.
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Consultations"),
        ),
        body: StreamBuilder(
          stream: recentJobsRef
              .child("AllRequestedChats")
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
                  Item items = new Item(
                    ref[key]["user"],
                    ref[key]["issue"],
                    ref[key]["time"],
                    ref[key]["timestamp"],
                  );
                  myItem.add(items);
                }

                return incomingMessage(myItem);
            }
          },
        ),
        floatingActionButton: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.blueAccent,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ConsultSpecialist()));
            },
            child: Text(
              "New Consultation",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget incomingMessage(List<Item> res) {
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                            child: Text('NAME:      ' + res[index].user),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                            child: Text('Issue:     ' + res[index].issue),
                          ),
                          Text('Time:   ' + res[index].time),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              trailing: InkWell(
                child: Text(
                  "View details",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              onTap: () {
                userName = res[index].user;
                _myChat(userName);
              },
            ),
          );
        });
  }
}

class Item {
  String user, issue, time, timestamp;

  Item(
    this.user,
    this.issue,
    this.time,
    this.timestamp,
  );
}
