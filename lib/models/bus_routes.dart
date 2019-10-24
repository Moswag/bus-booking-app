import 'dart:convert' as convert;

import 'package:bus_booking_app/constants/pref_constants.dart';
import 'package:bus_booking_app/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BusRoutes {
  int id;
  String from;
  String to;
  String amount;
  String departure_time;
  String expected_arrival_time;
  String max_passengers;
  String status;

  //Constructor
  BusRoutes({
    this.id,
    this.from,
    this.to,
    this.amount,
    this.departure_time,
    this.expected_arrival_time,
    this.max_passengers,
    this.status,
  });

  factory BusRoutes.fromJson(Map<String, dynamic> json) {
    BusRoutes newCompany = BusRoutes(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      amount: json['amount'],
      departure_time: json['departure_time'],
      expected_arrival_time: json['expected_arrival_time'],
      max_passengers: json['max_passengers'],
      status: json['status'],
    );

    return newCompany;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "from": from,
        "to": to,
        "amount": amount,
        "departure_time": departure_time,
        "expected_arrival_time": expected_arrival_time,
        "max_passengers": max_passengers,
        "status": status,
      };

  factory BusRoutes.fromRoute(BusRoutes anotherCompany) {
    return BusRoutes(
      id: anotherCompany.id,
      from: anotherCompany.from,
      to: anotherCompany.to,
      amount: anotherCompany.amount,
      departure_time: anotherCompany.departure_time,
      expected_arrival_time: anotherCompany.expected_arrival_time,
      max_passengers: anotherCompany.max_passengers,
      status: anotherCompany.status,
    );
  }
}

//Fetch data from Restful API

Future<List<BusRoutes>> fetchAllRoutes(
    http.Client client, int companyId, SharedPreferences prefs) async {
  print('$URL_COMPANY_ROUTES$companyId');
  final response = await client.get(prefs.getString(PrefConstants.IP_ADDRESS) +
      '$URL_COMPANY_ROUTES$companyId');
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['response'] == 'ok') {
      final users = mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return users.map<BusRoutes>((json) {
        return BusRoutes.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load User');
  }
}
