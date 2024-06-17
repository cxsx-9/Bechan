import 'dart:convert';
import 'dart:developer';
import 'package:bechan/models/secure_storage.dart';

import 'package:bechan/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:bechan/config.dart' as config;

class UserService {
  Future<dynamic> callApi(String method, dynamic data) async {
    log("[SERVICE] > method : " + method);
    try {
      dynamic response;

      if (method == 'login' || method == 'register') {
        response = await _get(method, data);
      } else if (method == 'user') {
        response = await _post(method);
      }

      return _handleResponse(response, method);
    } catch (e) {
      log('Error during API call: /$e');
      return Status(status: 'ERR_CONNECTION', message: 'Connection error'); // Return null if an error occurs
    }
  }

  Future<http.Response> _get(String method, dynamic data) async {
    dynamic response = await http.post(
        Uri.parse('${config.BASE_URL}/$method'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(data),
      );
    return response;
  }

  Future<http.Response> _post(String method) async {
    dynamic response = await http.get(
      Uri.parse('${config.BASE_URL}/$method'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${ await SecureStorage().getToken()}',
      },
    );
    return response;
  }

  Future<dynamic> _handleResponse(dynamic response, String method) async {
      log("[SERVICE] : status " + jsonDecode(response.body)['status'] + " !");
      if (response.statusCode == 200) {

        if (method == 'login' || method == 'register') {

          config.STATUS = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
          return config.STATUS;

        } else if (method == 'user') {

          if (jsonDecode(response.body)['status'] == 'error'){
            config.STATUS = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
            return config.STATUS;
          } else {
            config.USER_DATA = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
            return config.USER_DATA;
          }

        }
      } else {
        log("error : ${response.statusCode}");
        return Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>); // Return null for non-200 status codes
      }
  }
}