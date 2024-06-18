import 'dart:convert';
import 'package:bechan/models/secure_storage.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/api_service.dart';
import 'package:bechan/config.dart' as config;
import 'package:flutter/material.dart';

class UserService {

  Future<dynamic> login(dynamic data) async {
    print('[USVC] : login');
    dynamic response = await ApiService().callApi('get', 'login', data);
    if (response == null) {
      return errorUserService();
    }
    config.STATUS = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    if (config.STATUS.message == 'Login Success') {
      await SecureStorage().saveToken(config.STATUS.token);
    }
    return config.STATUS;
  }

  Future<dynamic> register(dynamic data) async {
    print('[USVC] : register');
    dynamic response = await ApiService().callApi('get', 'register', data);
    if (response == null) {
      return errorUserService();
    }
    config.STATUS = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return config.STATUS;
  }

  Future<dynamic> fetch() async {
    print('[USVC] : fetch');
    dynamic response = await ApiService().callApi('post', 'user', null);
    if (response == null) {
      return errorUserService();
    }
    config.USER_DATA = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    await SecureStorage().saveToken(config.USER_DATA.token);
    return config.USER_DATA;
  }

  Status errorUserService() {
    return Status(status: 'ERR_CONNECTION', message: 'Connection error');
  }

  void logout(context) {
    print('[USVC] : logout');
    SecureStorage().deleteToken();
    Navigator.pushReplacementNamed(context, '/loginPage');
  }
}