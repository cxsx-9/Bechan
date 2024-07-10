import 'dart:convert';
import 'package:bechan/models/favourite_transaction_model.dart';
import 'package:bechan/models/sum_month_model.dart';
import 'package:bechan/models/sum_year_model.dart';
import 'package:bechan/models/transaction_model.dart';
import 'package:bechan/models/transfer_data_model.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/api_service.dart';


class TransactionService {

  Future<dynamic> getTemplate() async {
    dynamic response = await ApiService().callApi('get', 'getExportTemplate', '');
    if (response == null) {
      return null;
    }
    return ResFileUrl.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> getAllTransactoin() async {
    dynamic response = await ApiService().callApi('get', 'getExcelUserTransactions', '');
    if (response == null) {
      return null;
    }
    return ResFileUrl.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> fetchSumM(String selectedMonth) async {
    dynamic response = await ApiService().callApi('get', 'summarymonth', '?selected_month=$selectedMonth');
    if (response == null) {
      return null;
    }
    return SumMonthResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> fetchSumY(String selectedYear) async {
    dynamic response = await ApiService().callApi('get', 'summaryyear', '?selected_year=$selectedYear');
    if (response == null) {
      return null;
    }
    return SumYearResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> fetchTransaction({String startDate = '', String endDate = '', int page = 1, int pageSize = 10, required Function onExpired}) async {
    dynamic response = await ApiService().callApi('get', 'summaryday', '?selected_date_start=$startDate&selected_date_end=$endDate&page=$page&pageSize=$pageSize');
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(res.message);
      if (res.message == 'Invalid or expired token') {
        onExpired();
        // UserService().logout(context);
      }
      return null;
    }
    return TransactionResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> fetchFav() async {
    dynamic response = await ApiService().callApi('get', 'getFavorite', '?fav=1');
    final jsonResponse = json.decode(response.body);
    if (response == null || jsonResponse['status'] == "error") {
      Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print(res.message);
      return null;
    }
    return FavouriteTransactionResposne.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> addTransaction(Object data) async {
    dynamic response = await ApiService().callApi('post', 'record', data);
    if (response == null) {
      return errorApiService();
    }
    Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    print(res.message);
    return response;
  }

  Future<dynamic> editTransaction(Object data) async {
    dynamic response = await ApiService().callApi('put', 'edit-transaction', data);
    if (response == null) {
      return errorApiService();
    }
    Status res = Status.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    print(res.message);
    return response;
  }

  Future<dynamic> deleteTransaction(Object data) async {
    dynamic response = await ApiService().callApi('delete', 'delete-transaction', data);
    if (response == null) {
      return errorApiService();
    }
    return response;
  }
}

class TagsService {
  
}