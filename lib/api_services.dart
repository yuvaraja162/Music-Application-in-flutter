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
      // print(data['data']);

      // print(productsFromJson(data['data']));
      return productsFromJson(data['data']);
      // print data['data'];
    }
  }

  static Future<List<ProductModel>?> getdetails() async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.productURL);

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //print(data);
      //var tagObjsJson = jsonDecode(data)['tags'] as List;
      // List<SearchModel> tagObjs =
      //     data.map((tagJson) => SearchModel.fromJson(tagJson)).toList();
      // print(data['data']);
      //print(tagObjs);
      return productsFromJson(data['data']);
      //return tagObjs;
      //return fromJson(data['data']);
    }
  }

  static Future<List<ProductModel>?> getresult(String keyword) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    String u = Config.resultURL + keyword;
    print(u);
    var url = Uri.http(Config.apiURL, Config.resultURL + keyword);

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //print(data);
      //var tagObjsJson = jsonDecode(data)['tags'] as List;
      // List<SearchModel> tagObjs =
      //     data.map((tagJson) => SearchModel.fromJson(tagJson)).toList();
      // print(data['data']);
      //print(tagObjs);
      return productsFromJson(data['data']);
      //return tagObjs;
      //return fromJson(data['data']);
    }
  }
}
