import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './all_chats.dart';

class Chat extends StatelessWidget {
  Chat(this.userId, this.thePatient);

  final String userId;
  final String thePatient;

  @override
  Widget build(BuildContext context) {
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
        DateFormat('EEEE, MMMM d;' + ' hh:mm aaa').format(DateTime.now());
    Firestore.instance
        .collection('chats')
        .document("$userId")
        .collection("$thePatient")
        .document()
        .setData(
            {'user': '$thePatient', 'message': '$text', 'time': '$theDate'});
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
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('chats')
            .document("$userId")
            .collection("$thePatient")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return Column(
                children: <Widget>[
                  incomingMessage(snapshot),
                ],
              );
          }
        },
      ),
    );
  }
}

Widget incomingMessage(AsyncSnapshot<QuerySnapshot> snapshot) {
  return Expanded(
    child: ListView(
      children: snapshot.data.documents.map((DocumentSnapshot document) {
        if (document['message'] == "incoming") {
          return chatListItem(document, CrossAxisAlignment.start);
        } else {
          return chatListItem(document, CrossAxisAlignment.end);
        }
      }).toList(),
    ),
  );
}

Widget chatListItem(DocumentSnapshot document, CrossAxisAlignment side) {
  if (document['message'] == null) {
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
                  document['user'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                  child: Text(
                    document['message'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  document['time'],
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
