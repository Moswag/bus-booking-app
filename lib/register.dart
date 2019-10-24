import 'package:bus_booking_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/pref_constants.dart';
import 'models/user.dart';
import 'ui/hotelBooking/hotelHomeScreen.dart';
import 'ui/widgets/loading.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title, this.prefs}) : super(key: key);

  final SharedPreferences prefs;
  final String title;

  @override
  State createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool _autoValidate = false;
  bool _loadingVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController surnameController = new TextEditingController();
  TextEditingController nationalIdController = new TextEditingController();
  TextEditingController phonenumberController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  Future _addUser({User user}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        await saveUser(http.Client(), user.toJson(), widget.prefs)
            .then((onValue) {
          if (onValue) {
            AlertDialog alertDialog = AlertDialog(
                title: Text('Response'),
                content: Text(widget.prefs.getString(
                    PrefConstants.SERVER_RESPONSE ?? 'Something is wrong')),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          new FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text('Ok', textScaleFactor: 1.5),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HotelHomeScreen(
                                            prefs: widget.prefs,
                                          )));
                            },
                          ),
                        ],
                      ))
                ]);

            showDialog(context: context, builder: (_) => alertDialog);
          } else {
            AlertDialog alertDialog = AlertDialog(
                title: Text('Response'),
                content: Text(widget.prefs.getString(
                    PrefConstants.SERVER_RESPONSE ?? 'Something is wrong')),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          new FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text('Ok', textScaleFactor: 1.5),
                            onPressed: () {
                              _loadingVisible = false;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegisterPage(
                                            prefs: widget.prefs,
                                          )));
                            },
                          ),
                        ],
                      ))
                ]);

            showDialog(context: context, builder: (_) => alertDialog);
          }
        });
      } catch (e) {
        print("Sign Up Error: $e");
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    void showAlertDialog({String message}) {}

    final nameField = TextFormField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.text,
      autofocus: true,
      controller: nameController,
      validator: Validator.validateName,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );
    final surnameField = TextFormField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: surnameController,
      validator: Validator.validateName,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Surname",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );

    final nationalIdField = TextFormField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: nationalIdController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "National Id",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );

    final phonenumberField = TextFormField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.number,
      autofocus: false,
      controller: phonenumberController,
      validator: Validator.validateNumber,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phonenumber",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );
    final addressField = TextFormField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: addressController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );

    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      autofocus: false,
      controller: passwordController,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final confirmPasswordField = TextFormField(
      obscureText: true,
      style: style,
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: confirmPasswordController,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Confirm Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01286D),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          //update an existing task
          if (widget.prefs.getString(PrefConstants.IP_ADDRESS) != null) {
            final snackBar = SnackBar(
                content: Text("Ip Address is: " +
                    widget.prefs.getString(PrefConstants.IP_ADDRESS)));
            Scaffold.of(context).showSnackBar(snackBar);
            User user = new User();
            user.id = '1';
            user.name = nameController.text;
            user.surname = surnameController.text;
            user.national_id = nationalIdController.text;
            user.phonenumber = phonenumberController.text;
            user.address = addressController.text;
            user.password = passwordController.text;

            _addUser(user: user);
          } else {
            final snackBar = SnackBar(
                content: Text(
                    "Ip Address is not set, please do so before procceding"));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final backButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffFAB904),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Back To Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    Form form = new Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Color(0xffF6F6F6),
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "assets/images/bus_booking.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    nameField,
                    SizedBox(height: 20.0),
                    surnameField,
                    SizedBox(height: 20.0),
                    nationalIdField,
                    SizedBox(height: 20.0),
                    phonenumberField,
                    SizedBox(height: 20.0),
                    addressField,
                    SizedBox(height: 20.0),
                    passwordField,
                    SizedBox(height: 20.0),
                    confirmPasswordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    registerButton,
                    SizedBox(height: 25.0),
                    backButton,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));

    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      body: LoadingScreen(child: form, inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
