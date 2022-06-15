import 'dart:convert';

//import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dbhandler.dart';

class APIService {
  static var client = http.Client();

  //retrieve all product
  static Future<List<ProductModel>?> getsongs() async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.productURL);

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data['data']);

      print(productsFromJson(data['data']));
      return productsFromJson(data['data']);
      // print data['data'];
    }
  }
}
