import 'package:bechan/models/transfer_data_model.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/api_service.dart';
import 'dart:convert';

class FiletransferService {
  
  Future<dynamic> importFile(dynamic data) async {
    dynamic response = await ApiFileService().callApi('post', 'import-file', data);
    if (response == null) {
      return errorApiService();
    }
    Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    print(res.message);
    return ImportFileResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<dynamic> submit(dynamic data) async {
    dynamic response = await ApiService().callApi('post', 'import-excel', data);
    if (response == null) {
      return errorApiService();
    }
    Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    print(res.message);
    return SubmitFileResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<dynamic> confirm(dynamic data) async {
    dynamic response = await ApiService().callApi('post', 'import-excelAll', data);
    if (response == null) {
      return errorApiService();
    }
    Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    print(res.message);
    return SubmitFileResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

}