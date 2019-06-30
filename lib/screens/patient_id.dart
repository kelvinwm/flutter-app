import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PatientId extends StatefulWidget {
  @override
  _PatientIdState createState() => _PatientIdState();
}

class _PatientIdState extends State<PatientId> {
  String token;
  String deviceToken;
  bool _btnEnabled = true;
  bool _progressBarActive = false;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  var _patientformKey = GlobalKey<FormState>();
  final patientPhone = TextEditingController();

  Future<String> getToken() async {
    try {
      String username = 'Flul26xjagfy7uO3iFGPvMqBFQ2MmQI0';
      String password = 'HhqhxajYai6L49Va';

      final credentials = '$username:$password';
      final stringToBase64 = utf8.fuse(base64);
      final encodedCredentials = stringToBase64.encode(credentials);
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json", // or whatever
        HttpHeaders.authorizationHeader: "Basic $encodedCredentials",
      };
      Response r = await get(
          'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials',
          headers: headers);
      Map<String, dynamic> user = jsonDecode(r.body);

      setState(() {
        token = user['access_token'];
      });
      debugPrint((user['access_token']));
    } catch (e) {
      print(e);
    }
    return "Success!";
  }

  Future<String> _getPatientID(String phoneNumber) async {
    String newPhone = '254${phoneNumber.replaceFirst(new RegExp(r'0'), '')}';

    String stkUrl =
        "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest";

    String passKey =
        'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';

    String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    int shortCode = 174379;

    String stringPassToEncrypt = '$shortCode$passKey$timestamp';
    final stringToBase64 = utf8.fuse(base64);
    final myPassword = stringToBase64.encode(stringPassToEncrypt);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    String bodyRequest = '{"BusinessShortCode": "174379",'
        '"Password": "$myPassword",'
        '"Timestamp": "$timestamp",'
        '"TransactionType": "CustomerPayBillOnline",'
        '"Amount": "10",'
        '"PartyA": "$newPhone",'
        '"PartyB": "174379",'
        '"PhoneNumber": "$newPhone",'
        '"CallBackURL": "https://knhsystem.herokuapp.com/mpesa/$deviceToken",'
        '"AccountReference": "account",'
        '"TransactionDesc": "test" }';

    // make POST request
    try {
      Response response =
          await post(stkUrl, headers: headers, body: bodyRequest);
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if (user["errorMessage"] == "Invalid Access Token") {
        setState(() {
          _progressBarActive = false;
          _btnEnabled = true;
        });
        getToken();
      }
      if (user["errorMessage"] != null) {
        _progressBarActive = false;
        _btnEnabled = true;
        _errorAlert(user["errorMessage"]);
      }
    } catch (e) {
      print(e);
    }
    return "Success!";
  }

  // TODO progress bar
  Widget _showProgress() {
    return Center(
      child: _progressBarActive == true
          ? CircularProgressIndicator()
          : Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(),
            ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) {
        setState(() {
          _btnEnabled = true;
          _progressBarActive = false;
          _ackAlert(message);
        });
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _messaging.getToken().then((tokenDevice) {
      print("NIKO $tokenDevice");
      setState(() {
        deviceToken = tokenDevice;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Acquire Patient ID Online"),
        backgroundColor: Colors.green,
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
                        Image.asset(
                          'assets/lipa.png',
                          height: 150,
                        ),
                        Text(
                          "Please Enter Mpesa Phone Number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.green,
                          ),
                          textScaleFactor: 1.2,
                        ),

                        /*Patient Phone*/
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: TextFormField(
                            controller: patientPhone,
                            validator: (String value) {
                              if (value.trim().isEmpty ||
                                  value.trim().length < 10) {
                                return "Enter Valid Phone Number!";
                              }
                            },
                            decoration: InputDecoration(
                              errorStyle:
                                  TextStyle(color: Colors.red, fontSize: 15),
                              hintText: 'Enter Phone Number',
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                          ),
                        ),
                        _showProgress(),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.green,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width / 1.1,
                            onPressed: () {
                              if (_patientformKey.currentState.validate()) {
                                setState(() {
                                  _progressBarActive = true;
                                  Timer(const Duration(seconds: 3), () {
                                    debugPrint("KENYA $_btnEnabled");
//
                                    _btnEnabled == true
                                        ? _getPatientID(patientPhone.text)
                                        : null;

                                    _btnEnabled = false;
                                  });
                                });
                              }
                            },
                            child: Text(
                              "Lipa Na Mpesa",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
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

  void _ackAlert(Map<String, dynamic> message) {
    patientPhone.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("${message["data"]["title"]}"),
          content: Text("${message["data"]["message"]}"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _errorAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Error"),
          content: Text("$message"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
