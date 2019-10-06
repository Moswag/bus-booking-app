import 'dart:convert' as convert;

import 'package:bus_booking_app/constants/url_constants.dart';
import 'package:http/http.dart' as http;

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
    http.Client client, int companyId) async {
  print('$URL_COMPANY_ROUTES$companyId');
  final response = await client.get('$URL_COMPANY_ROUTES$companyId');
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

//fetch task by id

Future<BusRoutes> fetchCompanyById(http.Client client, int taskId) async {
  print('$URL_COMPANY_ROUTES$taskId');
  final response = await client.get('$URL_COMPANY_ROUTES$taskId');
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['result'] == 'ok') {
      var mapTask = mapResponse[0]['data'];
      return BusRoutes.fromJson(mapTask);
    } else {
      return BusRoutes();
    }
  } else {
    throw Exception('Failed to get detail task with Id={taskId}');
  }
}

//update a task
Future<bool> fetchCompany(
    http.Client client, Map<String, dynamic> params) async {
  print(params.toString());
  final response = await client.post(URL_LOGIN, body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    var mapResponse = responseBody[0]['response'];
    if (mapResponse == 'success') {
      print('Response ikuti ' + responseBody[0]['name']);
      return true;
    } else {
      print('Response ikuti ' + responseBody[0]['message']);
      return false;
    }
  } else {
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}
