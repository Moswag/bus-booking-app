import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/pref_constants.dart';
import 'login.dart';
import 'ui/widgets/loading.dart';

class SetIpPage extends StatefulWidget {
  SetIpPage({Key key, this.title, this.prefs}) : super(key: key);

  final SharedPreferences prefs;
  final String title;

  @override
  State createState() => _SetIpPageState();
}

class _SetIpPageState extends State<SetIpPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool _autoValidate = false;
  bool _loadingVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ipController = new TextEditingController();

  Future _addIP({String ip}) async {
    if (_formKey.currentState.validate()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      await _changeLoadingVisible();

      widget.prefs.setString(PrefConstants.IP_ADDRESS, 'http://' + ip);

      AlertDialog alertDialog = AlertDialog(
          title: Text('Response'),
          content: Text("IP address successfully set"),
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
                                builder: (BuildContext context) => LoginPage(
                                      prefs: widget.prefs,
                                    )));
                      },
                    ),
                  ],
                ))
          ]);

      showDialog(context: context, builder: (_) => alertDialog);
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
      controller: ipController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Ip Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
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

          _addIP(ip: ipController.text);
        },
        child: Text("Save",
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
