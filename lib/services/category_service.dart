import 'dart:convert';

import 'package:bechan/models/category_model.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/api_service.dart';

class CategoryService {
  Future<dynamic> fetchCategory() async {
    dynamic response = await ApiService().callApi('get', 'getcategories', '');
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(res.message);
      return null;
    }
    print(response.body);
    return CategoriesResponse.fromJson(jsonDecode(response.body));
  }
}