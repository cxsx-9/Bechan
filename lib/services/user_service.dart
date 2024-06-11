import 'dart:convert';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import '../config.dart' as config;

class UserService {
  Future<dynamic> callApi(String method, dynamic data) async {
    try {
      dynamic response;

      if (method == 'login' || method == 'register') {
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
            'Authorization': 'Bearer ${config.LOGIN_STATUS.token}',
          },
        );
      }

      if (response.statusCode == 200) {
        print(response.body);
        if (method == 'login' || method == 'register') {
          config.LOGIN_STATUS =
              Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
          return config.LOGIN_STATUS;
        } else if (method == 'user') {
          config.USER_DATA =
              User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
          return config.USER_DATA;
        }
      } else {
        print("error : ${response.statusCode}");
        return Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>); // Return null for non-200 status codes
      }
    } catch (e) {
      print('Error during API call: /$e');
      return Status(status: '0', message: 'Connection error'); // Return null if an error occurs
    }
  }
}
