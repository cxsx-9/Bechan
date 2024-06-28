
import 'dart:convert';

import 'package:bechan/models/tag_model.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/api_service.dart';
import 'package:bechan/config.dart' as config;

class TagService {
  Future<dynamic> fetchTag() async {
    dynamic response = await ApiService().callApi('get', 'getTags', '');
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(res.message);
      return null;
    }
    config.TAG = TagResponse.fromJson(jsonDecode(response.body));
    return config.TAG;
  }

  Future<dynamic> addTag(Object data) async {
    dynamic response = await ApiService().callApi('post', 'createTags', data);
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(res.message);
      return null;
    }
    return response;
  }

  Future<dynamic> editTag(Object data) async {
    dynamic response = await ApiService().callApi('put', 'edit-tag', data);
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(res.message);
      return null;
    }
    return response;
  }

  Future<dynamic> deleteTag(Object data) async {
    dynamic response = await ApiService().callApi('delete', 'delete-tag', data);
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(res.message);
      return null;
    }
    return response;
  }
}