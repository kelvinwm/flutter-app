import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Book_me.dart';

class AllClinics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Our Clinics"),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
            height: 80,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                onTap: () {
                  _getBookingTime('Cancer Treatment Clinic', context);
                },
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 10, 5, 1),
                    child: Text(
                      "Cancer Treatment Clinic",
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
                      "Monday to Thursday, Fridays at Rahimtula",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                onTap: () {
                  _getBookingTime('ENT Clinic', context);
                },
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 10, 5, 1),
                    child: Text(
                      "ENT Clinic",
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
                      "Emergency Treatment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getBookingTime(String clinic, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('booked_clinic', clinic);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => BookNew(clinic, "NO", "")));
  }
}
