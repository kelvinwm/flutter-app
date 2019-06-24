import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chats_screen.dart';
import 'consult_specialist.dart';

class AllChats extends StatefulWidget {
  AllChats(this.userId);

  final String userId;

  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  String userName;

  void _myChat(String userName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Chat(widget.userId, userName)));
  }

  @override
  Widget build(BuildContext context) {
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
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('chats')
              .document("${widget.userId}")
              .collection("ALLCHATSHERE129")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return Column(
                  children: <Widget>[
                    incomingMessage(snapshot),
                  ],
                );
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

  Widget incomingMessage(AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                            child: Text('NAME:      ' + document['user']),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                            child: Text('Issue:     ' + document['issue']),
                          ),
                          Text('Time:   ' + document['time']),
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
                userName = document['user'];
                _myChat(userName);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
