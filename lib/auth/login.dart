import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});

  final Auth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

enum FormType { verifyPhone, confirmCode }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  String _codeVerify, _phone;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FormType _formType = FormType.verifyPhone;

  ///SETTING STATUS
  bool _progressBarActive = false;
  bool _absorbPointer = false;
  bool _disableTextField = true;

  String _message = '';
  String _verificationId;

  void resendCode() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.verifyPhone;
    });
  }

  void _getUserUid(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  // Exmaple code of how to veify phone number
  void _verifyPhoneNumber() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      // TODO: Login
      formState.save();
      setState(() {
        _message = '';
        _progressBarActive = true;
        _absorbPointer = true;
        _disableTextField = false;
      });
      try {
        final PhoneVerificationCompleted verificationCompleted =
            (AuthCredential user) {
          setState(() {
            print(
                'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
          });
        };

        final PhoneVerificationFailed verificationFailed =
            (AuthException authException) {
          setState(() {
            _message =
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
            _progressBarActive = false;
            _absorbPointer = false;
            _disableTextField = true;
          });
        };

        final PhoneCodeSent codeSent =
            (String verificationId, [int forceResendingToken]) async {
//          widget.context.showSnackBar(
//            SnackBar(
//              content: const Text(
//                  'Please check your phone for the verification code.'),
//            ),
//          );
          setState(() {
            _formType = FormType.confirmCode;
            _verificationId = verificationId;
            _formKey.currentState.reset();
            _progressBarActive = false;
            _absorbPointer = false;
            _disableTextField = true;
          });
        };

        final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
            (String verificationId) {
          _verificationId = verificationId;
        };

        await _auth.verifyPhoneNumber(
            phoneNumber: _phone,
            timeout: const Duration(seconds: 5),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      } catch (e) {
        setState(() {
          _message =
              "Please enter a valid phone number in the correct format. eg +254 712 345 678";
          _progressBarActive = false;
          _absorbPointer = false;
          _disableTextField = true;
          debugPrint(e);
        });
      }
    }
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      // TODO: Login
      formState.save();
      setState(() {
        _message = '';
        _progressBarActive = true;
        _absorbPointer = true;
        _disableTextField = false;
      });
      try {
        final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: _verificationId,
          smsCode: _codeVerify,
        );
        final FirebaseUser user = await _auth.signInWithCredential(credential);
        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);
        setState(() {
          if (user != null) {
            _message = 'Successfully signed in, uid: ' + user.uid;
            _progressBarActive = false;
            _absorbPointer = false;
            _disableTextField = true;
            _getUserUid(user.uid);
            widget.onSignedIn();
          } else {
            _message = 'Sign in failed';
            _progressBarActive = false;
            _absorbPointer = false;
            _disableTextField = true;
          }
        });
      } catch (e) {
        setState(() {
          debugPrint(e);
          _message = "Invalid verification code";
          _progressBarActive = false;
          _absorbPointer = false;
          _disableTextField = true;
        });
      }
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome login"),
        ),
        body: AbsorbPointer(
          absorbing: _absorbPointer,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  _showLogo(),
                  _showPhoneInput(),
                  _showProgress(),
                  _showLoginButton(),
                  _showSignIn(),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _message,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _showLogo() {
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }

  Widget _showPhoneInput() {
    if (_formType == FormType.verifyPhone) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          enabled: _disableTextField,
          maxLines: 1,
          keyboardType: TextInputType.phone,
          autofocus: false,
          decoration: InputDecoration(
              labelText: 'Enter Phone number',
              hintText: 'eg. +254 712 345 678',
              icon: Icon(
                Icons.phone,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Phone Number can\'t be empty' : null,
          onSaved: (value) => _phone = value,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          enabled: _disableTextField,
          keyboardType: TextInputType.phone,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Verification code',
              icon: Icon(
                Icons.verified_user,
                color: Colors.green,
              )),
          validator: (value) =>
              value.isEmpty ? 'Please enter Verification code' : null,
          onSaved: (value) => _codeVerify = value,
        ),
      );
    }
  }

  Widget _showLoginButton() {
    if (_formType == FormType.verifyPhone) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.blueAccent,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              _verifyPhoneNumber();
            },
            child: Text(
              "Send Verification Code",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.blueAccent,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              _signInWithPhoneNumber();
            },
            child: Text(
              "Submit Verification Code",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  Widget _showSignIn() {
    if (_formType == FormType.verifyPhone) {
      return Text("");
    } else {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: GestureDetector(
              child: Text("Resend code?!",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.blue)),
              onTap: () {
                resendCode();
              }),
        ),
      );
    }
  }
}
