import 'dart:convert';
import 'package:bechan/models/transaction_model.dart';
import 'package:bechan/services/api_service.dart';


class TransactionService {
  Future<dynamic> fethcDate(String startDate, String endDate) async {
    print('[TSVC] : transaction calling');
    dynamic response = await ApiService().callApi('get', 'summaryday', '?selected_date_start=$startDate&selected_date_end=$endDate');
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      print('[TSVC] : transaction Error');
      return null;
      // return errorApiService();
    }
    // print(response.body);
    print('[TSVC] : transaction ok!');
    return TscnResponse.fromJson(jsonDecode(response.body));
  }  
}