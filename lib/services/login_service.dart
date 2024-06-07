import 'dart:convert';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import '../config.dart' as config;

class LoginService {
  final String method;

  LoginService(this.method);

   Future<String> callApi(String username, String password) async {
    final res = await http.post(
      Uri.parse('${config.BASE_URL}/$method'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
      }),
    );

    Status status = Status();
      if (res.statusCode == 200) {
        status = Status.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
        print(res.body);
        return status.message;
      } else {
        print("error : ${res.statusCode}");
        return "Can not loging in now."; // Return null for non-200 status codes
      }
  }



}
