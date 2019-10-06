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
//Controllers =" functions relating to Task

Future<List<BookBus>> fetchBookBus(http.Client client, int userId) async {
  print('$URL_COMPANY_ROUTES$userId');
  final response = await client.get('$URL_COMPANY_ROUTES$userId');
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['result'] == 'ok') {
      final users = mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return users.map<BookBus>((json) {
        return BookBus.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load BookBus');
  }
}

//fetch task by id

Future<BookBus> fetchTaskById(http.Client client, int taskId) async {
  print('$URL_COMPANY_ROUTES$taskId');
  final response = await client.get('$URL_COMPANY_ROUTES$taskId');
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['result'] == 'ok') {
      var mapTask = mapResponse[0]['data'];
      return BookBus.fromJson(mapTask);
    } else {
      return BookBus();
    }
  } else {
    throw Exception('Failed to get detail task with Id={taskId}');
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

//update a task
Future<bool> loginUser(http.Client client, SharedPreferences prefs,
    Map<String, dynamic> params) async {
  print(params.toString());
  final response = await client.post(URL_LOGIN, body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    var mapResponse = responseBody[0]['response'];
    if (mapResponse == 'success') {
      print('Response ikuti ' + responseBody[0]['name']);
      prefs.setString(PrefConstants.LOGGED_NAME, responseBody[0]['name']);
      return true;
    } else {
      print('Response ikuti ' + responseBody[0]['message']);
      return false;
    }
  } else {
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}

//update a task
Future<BookBus> updateUser(
    http.Client client, Map<String, dynamic> params) async {
  final response =
      await client.put('$URL_COMPANY_ROUTES/${params["id"]}', body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    var mapTask = responseBody[0]['data'];
    return BookBus.fromJson(mapTask);
  } else {
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}

Future<BookBus> deleteTask(http.Client client, int id) async {
  final response = await client.delete('$URL_COMPANY_ROUTES/$id');
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    return BookBus.fromJson(responseBody[0]["data"]);
  } else {
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}
