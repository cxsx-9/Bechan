import 'dart:convert';
import 'package:bechan/models/transaction_model.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/api_service.dart';


class TransactionService {
  Future<dynamic> fetchDate(String startDate, String endDate) async {
    print('[TSVC] : transaction calling');
    dynamic response = await ApiService().callApi('get', 'summaryday', '?selected_date_start=$startDate&selected_date_end=$endDate');
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      print('[TSVC] : transaction Error');
      Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(res.message);
      return null;
    }
    // print(response.body);
    print('[TSVC] : transaction done');
    return TscnResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> addData(Object data) async {
    print('[TSVC] : transaction Add Data');
    dynamic response = await ApiService().callApi('post', 'record', data);
    if (response == null) {
      return errorApiService();
    }
    Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    print(res.message);
    print('[TSVC] : Add Data success!');
    return response;
  }

  Future<dynamic> editData(Object data) async {
    print('[TSVC] : transaction Edit Data');
    dynamic response = await ApiService().callApi('put', 'edit-transaction', data);
    if (response == null) {
      return errorApiService();
    }
    Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    print(res.message);
    print('[TSVC] : Edit Data success!');
    return response;
  }

  Future<dynamic> deleteData(Object data) async {
    dynamic response = await ApiService().callApi('delete', 'delete-transaction', data);
    if (response == null) {
      return errorApiService();
    }
    // Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // print(res.message);
    return response;
  }
}

class TagsService {
  
}