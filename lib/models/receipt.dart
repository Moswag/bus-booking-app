import 'dart:convert' as convert;

import 'package:bus_booking_app/constants/pref_constants.dart';
import 'package:bus_booking_app/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Receipt {
  int id;
  String route_id;
  String name;
  String national_id;
  String phonenumber;
  String to;
  String from;
  String amount;
  String status;
  String date;
  String sit_number;
  String departure_time;
  String expected_arrival_time;

  //Constructor
  Receipt(
      {this.id,
      this.route_id,
      this.name,
      this.national_id,
      this.phonenumber,
      this.to,
      this.from,
      this.amount,
      this.status,
      this.date,
      this.sit_number,
      this.departure_time,
      this.expected_arrival_time});

  factory Receipt.fromJson(Map<String, dynamic> json) {
    Receipt newReceipt = Receipt(
      id: json['id'],
      route_id: json['route_id'],
      name: json['name'],
      national_id: json['national_id'],
      phonenumber: json['phonenumber'],
      to: json['to'],
      from: json['from'],
      amount: json['amount'],
      status: json['status'],
      date: json['date'],
      sit_number: json['sit_number'],
      departure_time: json['departure_time'],
      expected_arrival_time: json['expected_arrival_time'],
    );

    return newReceipt;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "route_id": route_id,
        "name": name,
        "national_id": national_id,
        "phonenumber": phonenumber,
        "to": to,
        "from": from,
        "amount": amount,
        "status": status,
        "date": date,
        "sit_number": sit_number,
        "departure_time": departure_time,
        "expected_arrival_time": expected_arrival_time,
      };
}

//Fetch data from Restful API

Future<List<Receipt>> fetchMyReceipts(
    http.Client client, String phonenumber, SharedPreferences prefs) async {
  print('$URL_GET_RECEIPTS$phonenumber');
  final response = await client.get(prefs.getString(PrefConstants.IP_ADDRESS)+'$URL_GET_RECEIPTS$phonenumber');
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['response'] == 'success') {
      final receipts = mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return receipts.map<Receipt>((json) {
        return Receipt.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load receipts');
  }
}


