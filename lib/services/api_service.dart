import 'dart:convert';
import 'package:bechan/models/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bechan/config.dart' as config;

class ApiService {

  Future<dynamic> callApi(String method, String endPoint, dynamic data) async {
    print('[API] $method, $endPoint, $data');
    try {
      dynamic response;
      if (method == 'get') {
        response = await _get(endPoint, data);
      } else if (method == 'post') {
        response = await _post(endPoint);
      } else {
        print('[API] : unknown type : $method');
      }

      if (response.statusCode != 200) {
        return null;
      }
      return response;
    } catch (e) {
      print('[API] : Error during API call >> \n"$e"\n\n');
      return null;
    }
  }

  Future<http.Response> _get(String endPoint, dynamic data) async {
    dynamic response = await http.post(
        Uri.parse('${config.BASE_URL}/$endPoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(data),
      );
    return response;
  }

  Future<http.Response> _post(String endPoint) async {
    dynamic response = await http.get(
      Uri.parse('${config.BASE_URL}/$endPoint'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${ await SecureStorage().getToken()}',
      },
    );
    return response;
  }

}