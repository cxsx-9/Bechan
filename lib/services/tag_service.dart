import 'dart:convert';
import 'package:bechan/models/tag_model.dart';
import 'package:bechan/services/api_service.dart';
import 'package:bechan/config.dart' as config;

class TagService {
  Future<dynamic> fetchTag() async {
    dynamic response = await ApiService().callApi('get', 'getTags', '');
    if (response == null || json.decode(response.body)['status'] == "error") {
      return null;
    }
    config.TAG = TagResponse.fromJson(jsonDecode(response.body));
    return config.TAG;
  }

  Future<dynamic> addTag(Object data) async {
    dynamic response = await ApiService().callApi('post', 'createTags', data);
    if (response == null || json.decode(response.body)['status'] == "error") {
      return null;
    }
    return response;
  }

  Future<dynamic> editTag(Object data) async {
    dynamic response = await ApiService().callApi('put', 'edit-tag', data);
    if (response == null || json.decode(response.body)['status'] == "error") {
      return null;
    }
    return response;
  }

  Future<dynamic> deleteTag(Object data) async {
    dynamic response = await ApiService().callApi('delete', 'delete-tag', data);
    if (response == null || json.decode(response.body)['status'] == "error") {
      return null;
    }
    return response;
  }
}