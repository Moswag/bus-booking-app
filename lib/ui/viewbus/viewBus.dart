import 'package:bus_booking_app/constants/pref_constants.dart';
import 'package:bus_booking_app/models/book_bus.dart';
import 'package:bus_booking_app/models/bus_routes.dart';
import 'package:bus_booking_app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  BusRoutes route;
  SharedPreferences prefs;

  DetailPage({Key key, this.route, this.prefs}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DetailPage> {
  DateTime selectedDate = DateTime.now();
  bool isTapped = false;

  TextEditingController dateController = new TextEditingController();

  String phonenumber;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        isTapped = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: 3,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final coursePrice = Container(
      padding: const EdgeInsets.all(13.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "RTGS " + widget.route.amount.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30.0),
        Icon(
          Icons.directions_bus,
          color: Colors.white,
          size: 20.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          'From: ' + widget.route.from,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        Text(
          'To: ' + widget.route.to,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        Text(
          'Depature Time: ' + widget.route.departure_time,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        Text(
          'Expected Arrival Time: ' + widget.route.expected_arrival_time,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Text('Amount: ',
                    style: TextStyle(color: Colors.white, fontSize: 20.0))),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: coursePrice,
                )),
            // Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/bus_booking.png"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final date = GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: new Text(
        (this.isTapped)
            ? this.selectedDate.toString().substring(0, 10)
            : "Pick Date",
        style: TextStyle(),
      ),
    );

    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: (() {
            if (!this.isTapped) {
              MyAlertDialog.showAlertDialog(
                  title: 'Response',
                  message: 'Please pick a travelling date',
                  myContext: context);
            } else {
              if (!selectedDate.isAfter(DateTime.now())) {
                MyAlertDialog.showAlertDialog(
                    title: 'Response',
                    message:
                        'Please note that you can only book from tomorrow going forwad, please choose a different day',
                    myContext: context);
              } else {
                int days = selectedDate.difference(DateTime.now()).inDays;
                if (days > 10) {
                  MyAlertDialog.showAlertDialog(
                      title: 'Response',
                      message:
                          'Please note that you can only book 10 days from today, please choose a different day',
                      myContext: context);
                } else {
                  BookBus book = new BookBus();
                  book.id = '1';
                  book.phonenumber = widget.prefs
                      .getString(PrefConstants.LOGGED_PHONE)
                      .toString();

                  book.date = selectedDate.toString().substring(0, 10);
                  book.route_id = widget.route.id.toString();
                  print(book.toString());
                  bookBus(http.Client(), book.toJson(), widget.prefs)
                      .then((onValue) {
                    if (onValue) {
                      MyAlertDialog.showAlertDialog(
                          title: 'Response',
                          message: widget.prefs
                              .getString(PrefConstants.SERVER_RESPONSE),
                          myContext: context);
                    } else {
                      MyAlertDialog.showAlertDialog(
                          title: 'Response',
                          message: widget.prefs
                              .getString(PrefConstants.SERVER_RESPONSE),
                          myContext: context);
                    }
                  });
                }
              }
            }
          }),
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Text("Book Bus", style: TextStyle(color: Colors.white)),
        ));

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[date, readButton],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}
