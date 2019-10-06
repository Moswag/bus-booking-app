import 'dart:convert' as convert;

import 'package:bus_booking_app/constants/url_constants.dart';
import 'package:http/http.dart' as http;

class Company {
  int id;
  String name;
  String mission;
  String imageUrl;

  //Constructor
  Company({this.id, this.name, this.mission, this.imageUrl});

  factory Company.fromJson(Map<String, dynamic> json) {
    Company newCompany = Company(
        id: json['id'],
        name: json['name'],
        mission: json['mission'],
        imageUrl: json['imageUrl']);

    return newCompany;
  }

  Map<String, dynamic> toJson() =>
      {"name": name, "surname": mission, "imageUrl": imageUrl};

  factory Company.fromCompany(Company anotherCompany) {
    return Company(
        id: anotherCompany.id,
        name: anotherCompany.name,
        mission: anotherCompany.mission,
        imageUrl: anotherCompany.imageUrl);
  }
}

//Fetch data from Restful API
Future<List<Company>> fetchAllCompanies(http.Client client) async {
  final response = await client.get(URL_COMPANIES);

  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);

    if (mapResponse[0]['response'] == "ok") {
      final products = mapResponse[0]["data"].cast<Map<String, dynamic>>();

      print(products.runtimeType);
      print(mapResponse[0]["data"]);
      final listOfProducts = await products.map<Company>((json) {
        return Company.fromJson(json);
      }).toList();
      return listOfProducts;
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load Todo from the internet');
  }
}

Future<List<Company>> fetchCompanies(http.Client client, int userId) async {
  print('$URL_COMPANY_ROUTES$userId');
  final response = await client.get('$URL_COMPANY_ROUTES$userId');
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['response'] == 'ok') {
      final users = mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return users.map<Company>((json) {
        return Company.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load User');
  }
}

//fetch task by id

Future<Company> fetchCompanyById(http.Client client, int taskId) async {
  print('$URL_COMPANY_ROUTES$taskId');
  final response = await client.get('$URL_COMPANY_ROUTES$taskId');
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['result'] == 'ok') {
      var mapTask = mapResponse[0]['data'];
      return Company.fromJson(mapTask);
    } else {
      return Company();
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
