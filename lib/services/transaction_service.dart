import 'dart:convert';
import 'package:bechan/models/transaction_model.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/api_service.dart';
import 'package:flutter/material.dart';


class TransactionService extends ChangeNotifier {
  Future<dynamic> fetchDate(String startDate, String endDate) async {
    print('[TSVC] : transaction calling');
    dynamic response = await ApiService().callApi('get', 'summaryday', '?selected_date_start=$startDate&selected_date_end=$endDate');
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      print('[TSVC] : transaction Error');
      return null;
    }
    // print(response.body);
    print('[TSVC] : transaction ok!');
    return TscnResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> addData(Object data) async {
    dynamic response = await ApiService().callApi('post', 'record', data);
    if (response == null) {
      return errorApiService();
    }
    Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    print(res.message);
    notifyListeners();
    return response;
  }
}