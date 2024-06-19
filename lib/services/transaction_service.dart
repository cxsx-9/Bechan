import 'dart:convert';
import 'package:bechan/models/transaction_model.dart';
import 'package:bechan/services/api_service.dart';


class TransactionService {
  Future<dynamic> fethcDate(String date) async {
    print('[TSVC] : transaction calling');
    dynamic response = await ApiService().callApi('get', 'summaryday', '?selected_date=$date');
    if (response == null) {
      print('[TSVC] : Error');
      return null;
      // return errorApiService();
    }
    print('[TSVC] : transaction ok!');
    return TscnResponse.fromJson(jsonDecode(response.body));
  }  
}