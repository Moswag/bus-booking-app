import 'dart:convert' as convert;

import 'package:bus_booking_app/constants/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Promotion {
  int id;
  String company_id;
  String company;
  String promotion;
  String status;

  //Constructor
  Promotion(
      {this.id, this.company_id, this.company, this.promotion, this.status});

  factory Promotion.fromJson(Map<String, dynamic> json) {
    Promotion newPromotion = Promotion(
        id: json['id'],
        company_id: json['company_id'],
        company: json['company'],
        promotion: json['promotion'],
        status: json['status']);

    return newPromotion;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": company_id,
        "company": company,
        "promotion": promotion,
        "status": status
      };
}

//Fetch data from Restful API

Future<List<Promotion>> fetchPromotions(
    http.Client client, SharedPreferences prefs) async {
  print(URL_PROMOTIONS);
  final response = await client.get(URL_PROMOTIONS);
  if (response.statusCode == 200) {
    var mapResponse = convert.jsonDecode(response.body);
    if (mapResponse[0]['response'] == 'success') {
      final receipts = mapResponse[0]['data'].cast<Map<String, dynamic>>();
      return receipts.map<Promotion>((json) {
        return Promotion.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load Promotions');
  }
}
