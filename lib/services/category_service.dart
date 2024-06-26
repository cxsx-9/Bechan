import 'dart:convert';
import 'package:bechan/models/category_model.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/api_service.dart';
import 'package:bechan/config.dart' as config;

class CategoryService {
  Future<dynamic> fetchCategory() async {
    dynamic response = await ApiService().callApi('get', 'getcategories', '');
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(res.message);
      return null;
    }
    // print(response.body);
    config.CATEGORY = CategoriesResponse.fromJson(jsonDecode(response.body));
    return config.CATEGORY;
  }
}