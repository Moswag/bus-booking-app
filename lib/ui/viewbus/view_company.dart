import 'package:bus_booking_app/models/bus_routes.dart';
import 'package:bus_booking_app/models/company.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'viewBus.dart';

class ViewCompany extends StatefulWidget {
  ViewCompany({this.company, this.prefs});
  Company company;
  SharedPreferences prefs;

  @override
  State createState() => _ViewCompanyState();
}

class _ViewCompanyState extends State<ViewCompany> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(widget.company.name),
          centerTitle: true,
        ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        //bottomNavigationBar: makeBottom,
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 160),
              child: FutureBuilder(
                future: fetchAllRoutes(
                    http.Client(), widget.company.id, widget.prefs),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  return snapshot.hasData
                      ? RouteList(
                          routes: snapshot.data,
                          prefs: widget.prefs,
                        )
                      : Container(
                          child: Center(
                          child: CircularProgressIndicator(),
                        ));
                },
              ),
            ),
            Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.company.imageUrl),
                      fit: BoxFit.contain),
                  boxShadow: [
                    new BoxShadow(color: Colors.black, blurRadius: 8.0)
                  ],
                  color: Colors.white),
            ),
          ],
        ));
  }
}

class RouteList extends StatelessWidget {
  RouteList({this.routes, this.prefs});
  final List<BusRoutes> routes;
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    ListView getNoteListView() {
      TextStyle titleStyle = Theme.of(context).textTheme.subhead;
      return ListView.builder(
        itemCount: routes.length,
        itemBuilder: (BuildContext context, int positon) {
          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.directions_bus)),
                  title: Text('From: ' + routes[positon].from,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'To: ' +
                          routes[positon].to +
                          '\nAmount: \$' +
                          routes[positon].amount +
                          '\nDeparture Time: ' +
                          routes[positon].departure_time +
                          '\nExpected Arrival Time: ' +
                          routes[positon].expected_arrival_time,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  trailing: GestureDetector(
                    //to make the icon clickable and respond
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 25.0),
                    onTap: () {
                      Scaffold.of(context).showSnackBar(
                          new SnackBar(content: new Text('Book this bus')));
                    },
                  ),
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DetailPage(
                                route: routes[positon], prefs: prefs)));
                  },
                ),
              ));
        },
      );
    }

    return getNoteListView();
  }
}
