import 'dart:convert';

import 'package:dijital_garaj_app/put_response.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();
String baseUrl = "http://career.dijitalgaraj.com/hash/johnpaul-muoneme-48338";
String guid = '4f659157-63a1-418c-b311-585a6789a172';


Future<PutResponse> sendPutRequest() async {

  String jsonString = jsonEncode({'GUID' : guid});

  try{
    var response = await http.put(
      Uri.parse(baseUrl),
      body: jsonString,
      headers: { "Content-Type" : "application/json"}
    ).timeout(const Duration(seconds: 60), onTimeout: () async {
      return http.Response("Timeout Error", 600);
    });
    // print(response.body);
    PutResponse putResponse = putResponseFromJson(response.body);
    return putResponse;
  } catch(err){
    return PutResponse();
  }
}