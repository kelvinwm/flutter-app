import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import './all_chats.dart';

final recentJobsRef = FirebaseDatabase.instance
    .reference()
    .child('Bookclinics')
    .child("Chats")
    .child("Mychats");

class Chat extends StatelessWidget {
  Chat(this.userId, this.thePatient);

  final String userId;
  final String thePatient;

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);

    final textEditingController = TextEditingController();
    return WillPopScope(
      onWillPop: () async {
        /// Returning true allows the pop to happen, returning false prevents it.
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AllChats(userId)));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: ChatUi(userId, thePatient)),

            /// THE sending part
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: <Widget>[
                  // Button send image
                  Material(
                    child: new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 1.0),
                      child: new IconButton(
                        icon: new Icon(Icons.image),
                        onPressed: null,
                      ),
                    ),
                    color: Colors.white,
                  ),
                  // Edit text
                  Flexible(
                    child: Container(
                      child: TextField(
                        style: TextStyle(fontSize: 15.0),
                        controller: textEditingController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type your message...',
                        ),
                        autofocus: true,
//              focusNode: focusNode,
                      ),
                    ),
                  ),

                  // Button send message
                  Material(
                    child: new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 8.0),
                      child: new IconButton(
                        icon: new Icon(
                          Icons.send,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          if (textEditingController.text.trim().isEmpty) {
                            showToast(context, "Please enter message",
                                duration: Toast.LENGTH_LONG);
                            return;
                          }
                          _sendData(textEditingController.text);
                          textEditingController.clear();
                        },
                      ),
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
              width: double.infinity,
              height: 50.0,
              decoration: new BoxDecoration(
                  border: new Border(top: new BorderSide(width: 0.5)),
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _sendData(String text) {
    String theDate =
        DateFormat('EEEE, MMMM d y::' + ' hh:mm aaa').format(DateTime.now());
//        DateFormat('yyyy-MM-dd HH:mm aaa').format(DateTime.now());
    recentJobsRef.child(userId).child('$thePatient').push().set({
      'user': '$thePatient',
      'message': '$text',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'time': '$theDate'
    });

//    Firestore.instance
//        .collection('chats')
//        .document("$userId")
//        .collection("$thePatient")
//        .document()
//        .setData(
//            {'user': '$thePatient', 'message': '$text', 'time': '$theDate'});
  }

  void showToast(BuildContext context, String msg,
      {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}

class ChatUi extends StatelessWidget {
  ChatUi(this.userId, this.thePatient);

  final String userId;
  final String thePatient;

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase database;
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    return Scaffold(
      body: StreamBuilder(
        stream: recentJobsRef
            .child(userId)
            .child("$thePatient")
            .orderByChild('timestamp')
            .onValue,
        builder: (context, snap) {
          if (snap.hasError) {
            return Container(
              child: Center(
                child: Icon(Icons.error),
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
                Item items = new Item(ref[key]["user"], ref[key]["message"],
                    ref[key]["time"], ref[key]["timestamp"]);
                myItem.add(items);
              }
              return incomingMessage(myItem);
          }
        },
      ),

//      StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance
//            .collection('chats')
//            .document("$userId")
//            .collection("$thePatient")
//            .snapshots(),
//        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//          switch (snapshot.connectionState) {
//            case ConnectionState.waiting:
//              return CircularProgressIndicator();
//            default:
//              return Column(
//                children: <Widget>[
//                  incomingMessage(snapshot),
//                ],
//              );
//          }
//        },
//      ),
    );
  }
}

Widget incomingMessage(List<Item> res) {
  return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: res.length,
      itemBuilder: (context, index) {
        res.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        if (res[index].message == "incoming") {
          return chatListItem(res[index], CrossAxisAlignment.start);
        } else {
          return chatListItem(res[index], CrossAxisAlignment.end);
        }
      });

//    ListView(
//      children: snapshot.data.documents.map((DocumentSnapshot document) {
//        if (document['message'] == "incoming") {
//          return chatListItem(document, CrossAxisAlignment.start);
//        } else {
//          return chatListItem(document, CrossAxisAlignment.end);
//        }
//      }).toList(),
//    ),
}

Widget chatListItem(Item res, CrossAxisAlignment side) {
  if (res.message == null) {
    return Card(
      child: Text("Missing data"),
    );
  }
  return Card(
    child: Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 5, 20, 5),
            child: Column(
              // align the text to the left instead of centered
              crossAxisAlignment: side,
              children: <Widget>[
                Text(
                  res.user,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                  child: Text(
                    res.message,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  res.time,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class Item {
  String user, message, time, timestamp;

  Item(
    this.user,
    this.message,
    this.time,
    this.timestamp,
  );
}
