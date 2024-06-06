import 'dart:convert';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static const baseUrl = 'https://0512-49-0-64-52.ngrok-free.app';
  final String method;

  LoginService(this.method);

  Future<String?> callApi(String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/$method/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
      }),
    );

    final status;
      if (res.statusCode == 200) {
        print("API 200");
        status = Status.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
        return status.message;
      } else {
        print("API Error: Status code ${res.statusCode}");
        return "Can not loging in now."; // Return null for non-200 status codes
      }
  }



}
