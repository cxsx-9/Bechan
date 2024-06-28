import 'dart:convert';
import 'package:bechan/models/secure_storage.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/api_service.dart';
import 'package:bechan/config.dart' as config;
import 'package:flutter/material.dart';

class UserService {

  Future<dynamic> login(dynamic data) async {
    print('[USVC] : login');
    dynamic response = await ApiService().callApi('post', 'login', data);
    if (response == null) {
      return errorApiService();
    }
    config.STATUS = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    if (config.STATUS.message == 'Login Success') {
      await SecureStorage().saveToken(config.STATUS.token);
    }
    return config.STATUS;
  }

  Future<dynamic> register(dynamic data) async {
    print('[USVC] : register');
    dynamic response = await ApiService().callApi('post', 'register', data);
    if (response == null) {
      return errorApiService();
    }
    config.STATUS = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return config.STATUS;
  }

  Future<dynamic> fetch() async {
    print('[USVC] : fetch');
    dynamic response = await ApiService().callApi('get', 'user', '');
    if (response == null) {
      return errorApiService();
    }
    config.USER_DATA = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    await SecureStorage().saveToken(config.USER_DATA.token);
    return config.USER_DATA;
  }

  void logout(context) {
    print('[USVC] : logout');
    SecureStorage().deleteToken();
    Navigator.pushReplacementNamed(context, '/loginPage');
  }

  Future<dynamic> forgotPassword(dynamic data) async {
    print('[USVC] : forgotPassword');
    dynamic response = await ApiService().callApi('post', 'req-password-reset', data);
    if (response == null) {
      return errorApiService();
    }
    config.STATUS = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return config.STATUS;
  }

  Future<dynamic> verifyTokenPassword(dynamic data) async {
    print('[USVC] : forgotPassword');
    dynamic response = await ApiService().callApi('post', 'verify-token-password', data);
    if (response == null) {
      return errorApiService();
    }
    config.STATUS = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return config.STATUS;
  }

  Future<dynamic> setNewPassword(dynamic data) async {
    print('[USVC] : forgotPassword');
    dynamic response = await ApiService().callApi('post', 'setnewpassword', data);
    if (response == null) {
      return errorApiService();
    }
    config.STATUS = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return config.STATUS;
  }
}
