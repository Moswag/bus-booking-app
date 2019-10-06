import 'package:bus_booking_app/constants/app_contsants.dart';
import 'package:bus_booking_app/constants/pref_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import 'hotelBooking/hotelHomeScreen.dart';
import 'view_promotions.dart';
import 'view_receipts.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({this.prefs});

  final SharedPreferences prefs;

  bool _loadingVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = prefs.getBool(PrefConstants.ISLOGGEDIN) ?? false;
    if (!isLoggedIn) {
      return LoginPage(prefs: prefs);
    } else {
      final phonenumber = prefs.getString(PrefConstants.LOGGED_PHONE) ?? '07';
      final name = prefs.getString(PrefConstants.LOGGED_NAME) ?? 'Web';

      void _signOut() async {
        try {
          prefs.setBool(PrefConstants.ISLOGGEDIN, false);
          Navigator.of(context).pop();
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new LoginPage(prefs: prefs)));
        } catch (e) {
          print(e);
        }
      }

      void showAlertDialog() {
        AlertDialog alertDialog = AlertDialog(
            title: Text('Status'),
            content:
                Text('Are you sure you want to logout from Bus Booking App'),
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
                          _signOut(); //signout
                        },
                      ),
                      Container(
                        width: 5.0,
                      ),
                      new FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Colors.red,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ))
            ]);

        showDialog(context: context, builder: (_) => alertDialog);
      }

      return new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(phonenumber),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage(AppConstants.APP_LOGO),
              ),
            ),
            new ListTile(
              leading: Icon(Icons.home),
              title: new Text('Home'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext contex) =>
                            HotelHomeScreen(prefs: prefs)));
              },
            ),
            new ListTile(
              leading: Icon(Icons.fingerprint),
              title: new Text('Promotions'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext contex) =>
                            ViewPromotions(prefs: prefs)));

                //Navigator.of(context).pushNamed(MyRoutes.VIEW_SPORTS);
              },
            ),
            new ListTile(
              leading: Icon(Icons.textsms),
              title: new Text('Tickets'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext contex) =>
                            ViewReceipts(prefs: prefs)));

                //  Navigator.of(context).pushNamed(MyRoutes.VIEW_STUDENTS);
              },
            ),
            new ListTile(
              leading: Icon(Icons.developer_mode),
              title: new Text('About Developer'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: Icon(Icons.all_out),
              title: new Text('Logout'),
              onTap: () {
                //Navigator.pop(context);
                showAlertDialog(); // _signOut();
              },
            )
          ],
        ),
      );
    }
  }
}
