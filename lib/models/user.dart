import 'dart:convert' as convert;

import 'package:bus_booking_app/constants/pref_constants.dart';
import 'package:bus_booking_app/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String name;
  String surname;
  String national_id;
  String phonenumber;
  String address;
  String password;

  //Constructor
  User(
      {this.id,
      this.name,
      this.surname,
      this.national_id,
      this.phonenumber,
      this.address,
      this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    User newUser = User(
        id: json['id'].toString(),
        name: json['name'],
        surname: json['surname'],
        national_id: json['national_id'],
        phonenumber: json['phonenumber'],
        address: json['address'],
        password: json['password']);

    return newUser;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "national_id": national_id,
        "phonenumber": phonenumber,
        "address": address,
        "password": password
      };

  //clone a Task or copy constructor

  factory User.fromUser(User anotherUser) {
    return User(
        id: anotherUser.id,
        name: anotherUser.name,
        surname: anotherUser.surname,
        national_id: anotherUser.national_id,
        phonenumber: anotherUser.phonenumber,
        address: anotherUser.address);
  }
}

//update a task
Future<bool> saveUser(http.Client client, Map<String, dynamic> params,
    SharedPreferences prefs) async {
  print(params.toString());
  final response = await client.post(URL_REGISTER, body: params);
  print('response22=$response');
  if (response.statusCode == 200) {
    var responseBody = await convert.jsonDecode(response.body);
    var mapResponse = responseBody[0]['response'];
    if (mapResponse == 'success') {
      print('Response ikuti ' + responseBody[0]['message']);
      prefs.setString(
          PrefConstants.LOGGED_PHONE, responseBody[0]['phonenumber']);
      prefs.setString(PrefConstants.LOGGED_NAME, responseBody[0]['name']);
      prefs.setBool(PrefConstants.ISLOGGEDIN, true);
      prefs.setString(PrefConstants.COMPANY_COUNT,
          responseBody[0]['companiesCount'].toString());
      prefs.setString(
          PrefConstants.SERVER_RESPONSE, responseBody[0]['message']);
      return true;
    } else {
      print('Response ikuti ' + responseBody[0]['message']);
      prefs.setString(
          PrefConstants.SERVER_RESPONSE, responseBody[0]['message']);
      return false;
    }
  } else {
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
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
      prefs.setString(PrefConstants.COMPANY_COUNT,
          responseBody[0]['companiesCount'].toString());
      return true;
    } else {
      print('Response ikuti ' + responseBody[0]['message']);
      return false;
    }
  } else {
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}
