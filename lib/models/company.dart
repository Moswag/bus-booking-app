import 'dart:convert' as convert;

import 'package:bus_booking_app/constants/pref_constants.dart';
import 'package:bus_booking_app/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
Future<List<Company>> fetchAllCompanies(
    http.Client client, SharedPreferences prefs) async {
  final response = await client
      .get(prefs.getString(PrefConstants.IP_ADDRESS) + URL_COMPANIES);

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
