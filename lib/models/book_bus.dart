import 'dart:convert' as convert;

import 'package:bus_booking_app/constants/pref_constants.dart';
import 'package:bus_booking_app/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookBus {
  String id;
  String phonenumber;
  String route_id;
  String date;

  //Constructor
  BookBus({this.id, this.phonenumber, this.route_id, this.date});

  factory BookBus.fromJson(Map<String, dynamic> json) {
    BookBus newBookBus = BookBus(
        id: json['id'],
        phonenumber: json['phonenumber'],
        route_id: json['route_id'],
        date: json['date']);

    return newBookBus;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "phonenumber": phonenumber,
        "route_id": route_id,
        "date": date
      };

  //clone a Task or copy constructor

  factory BookBus.fromUser(BookBus anotherUser) {
    return BookBus(
      id: anotherUser.id,
      phonenumber: anotherUser.phonenumber,
      route_id: anotherUser.route_id,
      date: anotherUser.date,
    );
  }
}

//update a task
Future<bool> bookBus(http.Client client, Map<String, dynamic> params,
    SharedPreferences prefs) async {
  print(params.toString());
  print(URL_BOOK_BUS);
  final response = await client.post(URL_BOOK_BUS, body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    print(responseBody.toString());
    var mapResponse = responseBody[0]['response'];
    if (mapResponse == 'success') {
      prefs.setString(
          PrefConstants.SERVER_RESPONSE, responseBody[0]['message']);
      print('Response ikuti ' + responseBody[0]['message']);
      return true;
    } else {
      prefs.setString(
          PrefConstants.SERVER_RESPONSE, responseBody[0]['message']);
      return false;
    }
  } else {
    throw Exception('Failed to book bus. Error: ${response.toString()}');
  }
}
