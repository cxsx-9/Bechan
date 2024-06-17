import 'dart:convert';
import 'package:bechan/models/secure_storage.dart';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:bechan/config.dart' as config;

class UserService {
  Future<dynamic> callApi(String method, dynamic data) async {
    print("[SERVICE] > method : " + method);
    try {
      dynamic response;

      if (method == 'login' || method == 'register') {
        print(data);
        response = await http.post(
          Uri.parse('${config.BASE_URL}/$method'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(data),
        );
      } else if (method == 'user') {
        response = await http.get(
          Uri.parse('${config.BASE_URL}/$method'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${ await SecureStorage().getToken()}',
          },
        );
      }

      if (response.statusCode == 200) {

        print(response.body);
        print("[SERVICE] : status " + jsonDecode(response.body)['status'] + " !");

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
        print("error : ${response.statusCode}");
        return Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>); // Return null for non-200 status codes
      }
    } catch (e) {
      print('Error during API call: /$e');
      return Status(status: 'ERR_CONNECTION', message: 'Connection error'); // Return null if an error occurs
    }
  }
}
