import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'all_clinics.dart';
import '../screens/patient_id.dart';

class NewPatient extends StatefulWidget {
  @override
  _NewPatientState createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  var _patientFormKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final secondName = TextEditingController();
  final patientAge = TextEditingController();
  final phoneNumber = TextEditingController();
  final patientID = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Patient Details"),
      ),
      body: Container(
//        height: 470,
        margin: EdgeInsets.all(15.0),
        child: Container(
          margin: new EdgeInsets.all(15.0),
          child: Form(
            key: _patientFormKey,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Enter Patients Details",
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.blue),
                      textScaleFactor: 1.2,
                    ),
                    SizedBox(height: 15.0),

                    ///*First Name*/
                    TextFormField(
                      controller: firstName,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Enter First Name!";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'First Name',
                          errorStyle:
                              TextStyle(color: Colors.red, fontSize: 15),
                          hintText: 'First Name',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 12.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 15.0),

                    ///*Second Name*/
                    TextFormField(
                      controller: secondName,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Enter Second Name!";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Second Name',
                          hintText: 'Second Name',
                          errorStyle:
                              TextStyle(color: Colors.red, fontSize: 15),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 12.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 15.0),

                    ///*Patient Age*/
                    TextFormField(
                      controller: patientAge,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Enter Patient Age!";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Patient Age',
                          hintText: 'Patient Age',
                          errorStyle:
                              TextStyle(color: Colors.red, fontSize: 15),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 12.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                    ),

                    ///*Phone Number*/
                    TextFormField(
                      controller: phoneNumber,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Enter Phone Number!";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Phone Number',
                          errorStyle:
                              TextStyle(color: Colors.red, fontSize: 15),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 12.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                    ),
                    SizedBox(height: 15.0),

                    ///*Patrint ID*/
                    TextFormField(
                      controller: patientID,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Enter Patient ID!";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Patient ID',
                        errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                        hintText: 'Patient ID',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 12.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                    SizedBox(height: 5.0),

                    ///GET PATIENT ID BUTTON
                    Container(
                      alignment: Alignment.topRight,
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.blueGrey,
                        child: MaterialButton(
                          onPressed: () {
                            _getNewPatientDetails();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PatientId()));
                          },
                          child: Text(
                            "Get Patient ID",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),

                    ///NEXT BUTTON
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blueAccent,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () {
                          if (_patientFormKey.currentState.validate()) {
                            _getNewPatientDetails();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AllClinics()));
                          }
                        },
                        child: Text(
                          "Next",
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

  void _getNewPatientDetails() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('p_names', firstName.text + ' ' + secondName.text);
    prefs.setString('p_age', patientAge.text);
    prefs.setString('p_phone', phoneNumber.text);
    prefs.setString('patient_id', patientID.text);
  }
}
