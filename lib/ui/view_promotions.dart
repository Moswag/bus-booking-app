import 'package:bus_booking_app/constants/app_contsants.dart';
import 'package:bus_booking_app/models/promotion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home_drawer.dart';

class ViewPromotions extends StatefulWidget {
  SharedPreferences prefs;

  ViewPromotions({this.prefs});

  final String title = 'Promotions';

  @override
  State createState() => _ViewPromotionsState();
}

class _ViewPromotionsState extends State<ViewPromotions> {
  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Promotion promotion) => ListTile(
          leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.business_center)),
          title: Text(
            "Company :" + promotion.company,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    // tag: 'hero',

                    child: Text("Promotion : " + promotion.promotion,
                        style: TextStyle(color: Colors.white)),
                  )),
            ],
          ),
        );

    Card makeCard(Promotion promotion) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(promotion),
          ),
        );

    final header = Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConstants.APP_LOGO), fit: BoxFit.cover),
            boxShadow: [new BoxShadow(color: Colors.black, blurRadius: 8.0)],
            color: Colors.blue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Promotions',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: 'Roboto'),
            ),
            Icon(
              Icons.list,
              color: Colors.white,
              size: 30,
            )
          ],
        ));

    final makeBody = Padding(
        padding: EdgeInsets.only(top: 100),
        child: Container(
            decoration: BoxDecoration(color: Colors.greenAccent),
            child: FutureBuilder(
                future: fetchPromotions(http.Client(), widget.prefs),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text('Loading'),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return makeCard(new Promotion(
                            id: snapshot.data[index].id,
                            company_id: snapshot.data[index].company_id,
                            company: snapshot.data[index].company,
                            promotion: snapshot.data[index].promotion,
                            status: snapshot.data[index].status));
                      },
                    );
                  }
                })));

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Colors.greenAccent,
      title: Text(widget.title),
      centerTitle: true,
    );

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: topAppBar,
      drawer: HomeDrawer(
        prefs: widget.prefs,
      ),
      body: Stack(children: <Widget>[makeBody, header]),
    );
  }
}
