import 'dart:convert';
import 'package:bechan/models/category_model.dart';
import 'package:bechan/services/api_service.dart';
import 'package:bechan/config.dart' as config;

class CategoryService {
  Future<dynamic> fetchCategory() async {
    dynamic response = await ApiService().callApi('get', 'getcategories', '');
    if (response == null || json.decode(response.body)['status'] == "error") {
      return null;
    }
    config.CATEGORY = CategoriesResponse.fromJson(jsonDecode(response.body));
    return config.CATEGORY;
  }

  Future<dynamic> addCategory(Object data) async {
    dynamic response = await ApiService().callApi('post', 'createCategorie', data);
    if (response == null || json.decode(response.body)['status'] == "error") {
      return null;
    }
    return response;
  }

  Future<dynamic> editCategory(Object data) async {
    dynamic response = await ApiService().callApi('put', 'edit-categorie', data);
    if (response == null || json.decode(response.body)['status'] == "error") {
      return null;
    }
    return response;
  }

  Future<dynamic> deleteCategory(Object data) async {
    dynamic response = await ApiService().callApi('delete', 'delete-categorie', data);
    if (response == null || json.decode(response.body)['status'] == "error") {
      return null;
    }
    return response;
  }
}