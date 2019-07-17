import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import 'chats_screen.dart';

class ConsultSpecialist extends StatefulWidget {
  @override
  _ConsultSpecialistState createState() => _ConsultSpecialistState();
}

final recentJobsRef =
    FirebaseDatabase.instance.reference().child('Bookclinics').child("Chats");

class _ConsultSpecialistState extends State<ConsultSpecialist> {
  var _patientformKey = GlobalKey<FormState>();
  final patientNames = TextEditingController();
  final patientAge = TextEditingController();
  final patientDescription = TextEditingController();
  String userId;
  final List<String> _dropdownValues = [
    "General medication",
    "Women's Issue",
    "Stress and Mental health",
    "Skin problems",
    "Not sure!"
  ];
  String dropdownValue;

  String _radioValue; //Initial definition of radio button value
  String choice;

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'one':
          choice = "Male";
          break;
        case 'two':
          choice = "Female";
          break;
        default:
          choice = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consult a Specialist"),
      ),
      body: Builder(
        builder: (context) => Container(
              margin: EdgeInsets.all(5.0),
              child: Form(
                key: _patientformKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Please Enter Patients Details and the health issue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.blue,
                          ),
                          textScaleFactor: 1.2,
                        ),
                        SizedBox(height: 5.0),
                        /*Doctor Availability*/
                        ListTile(
                          leading: Icon(Icons.people),
                          title: Row(
                            children: <Widget>[
                              Text("DOCTORS:  "),
                              Container(
                                child: Text(
                                  "   Available",
                                  style: TextStyle(color: Colors.green),
                                ),
                              )
                            ],
                          ),
                        ),
                        /*Patient Names*/
                        ListTile(
                          leading: Icon(Icons.person),
                          title: TextFormField(
                            controller: patientNames,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Enter Pateint Names!";
                              }
                            },
                            decoration: InputDecoration(
                              errorStyle:
                                  TextStyle(color: Colors.red, fontSize: 15),
                              hintText: 'Enter Pateint Names',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        /*Patient Age*/
                        ListTile(
                          leading: Icon(Icons.label),
                          title: TextFormField(
                            controller: patientAge,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Enter Patient Age!";
                              }
                            },
                            decoration: new InputDecoration(
                              hintText: 'Patient Age eg.56',
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(23, 5, 0, 15),
                          child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "Gender :",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Radio(
                                value: 'one',
                                groupValue: _radioValue,
                                onChanged: radioButtonChanges,
                              ),
                              Text(
                                'Male',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              Radio(
                                value: 'two',
                                groupValue: _radioValue,
                                onChanged: radioButtonChanges,
                              ),
                              Text(
                                'Female',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*Patient description*/
                        ListTile(
                          title: TextFormField(
                            maxLines: 5,
                            controller: patientDescription,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Enter Patient health descripton!";
                              }
                            },
                            decoration: new InputDecoration(
                                hintText:
                                    'ENTER HEALTH ISSUE DESCRIPTION HERE \n'
                                    'eg. I have been suffering from fever since '
                                    'last 4 days and temperature start to raise at '
                                    'any time and reaches up to 102 degree.',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 20, 15, 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                value: dropdownValue,
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: _dropdownValues
                                    .map((value) => DropdownMenuItem(
                                          child: Text(value),
                                          value: value,
                                        ))
                                    .toList(),
                                isExpanded: true,
                                hint: Text('Choose Specaility'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.blueAccent,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width / 1.1,
                            onPressed: () {
                              if (_patientformKey.currentState.validate()) {
                                if (choice == null) {
                                  final snackBar = SnackBar(
                                      content: Text(
                                    'Choose patient Gender!',
                                    style: TextStyle(color: Colors.red),
                                  ));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                } else {
                                  _newPatientDetails();
//                                  print(
//                                    patientNames.text +
//                                        " " +patientAge.text+
//                                        choice +
//                                        patientDescription.text,
//                                  );
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Chat(
                                                  userId, patientNames.text)));
                                }
                              }
                            },
                            child: Text(
                              "Done",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  void _newPatientDetails() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('thePatient', patientNames.text);
    prefs.setString('patient_age', patientAge.text);
    prefs.setString('p_gender', choice);
    prefs.setString('p_Description', patientDescription.text);

    userId = prefs.getString('userId') ?? '';

    String message =
        'Name: ${patientNames.text} \nAge: ${patientAge.text} \nGender: $choice \nIssue: $dropdownValue \nDescription: ${patientDescription.text}';
    String theDate = DateFormat('EEEE, MMMM d y').format(DateTime.now());

    try {
      DatabaseReference newPostRef =
          recentJobsRef.child("AllRequestedChats").child(userId).push();

      newPostRef.set({
        'user': '${patientNames.text}',
        'issue': '$dropdownValue',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'time': '$theDate'
      });

      recentJobsRef
          .child("Mychats")
          .child(userId)
          .child(patientNames.text)
          .child(newPostRef.key)
          .set({
        'user': '${patientNames.text}',
        'message': '$message',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'time': '$theDate',
        'userUID': userId,
      });

      recentJobsRef.child("ReadfromSite").push().set({
        'user': '${patientNames.text}',
        'issue': '$dropdownValue',
        'userUID': userId,
        "Description": '${patientDescription.text}',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'time': '$theDate'
      });
    } catch (e) {
      print(e);
    }
  }
}
