import 'package:bechan/models/tag_model.dart';

class ResFileUrl {
  String status;
  String message;
  String url;

  ResFileUrl({
    String ? status,
    String ? message,
    String ? url,
  })
  :
    status =status ?? "" ,
    message =message ?? "" ,
    url =url ?? "" 
  ;

  factory ResFileUrl.fromJson(Map<String, dynamic> json) {
    return ResFileUrl(
        status: json['status'].runtimeType == "String" ? json['status']: json['status'].toString(),
        message: json['message'].runtimeType == "String" ? json['message']: json['message'].toString(),
        url: json['data'] != null ? json['data']['fileUrl'].runtimeType == "String" ? json['data']['fileUrl']: json['data']['fileUrl'].toString() : '',
      );
  }
}

class ErrTransaction {
  final String amount;
  final String note;
  final String transactionDatetime;
  final String categorieId;
  final String categorieName;
  final String fav;
  final List<Tag> tags;

  ErrTransaction({
    required this.amount,
    required this.note,
    required this.transactionDatetime,
    required this.categorieId,
    required this.categorieName,
    required this.fav,
    required this.tags,
  });

  factory ErrTransaction.fromJson(Map<String, dynamic> json) {
    var data = json['tag_id'];
    return ErrTransaction(
      amount: json['amount'].runtimeType == 'String' ? json['amount'] : json['amount'].toString(),
      note: json['note'] ?? '',
      transactionDatetime: json['transaction_datetime'],
      categorieId: json['categorie_id'].runtimeType == 'String' ? json['categorie_id'] : json['categorie_id'].toString(),
      categorieName: json['categorie_name'] ?? '',
      fav: json['fav'].runtimeType == 'String' ? json['fav'] : json['fav'].toString(),
      tags: data != [] ? (data as List).map((tags)=> Tag.fromJson(tags)).toList() : []
    );
  }
}

class ImportError {
  final String message;
  final ErrTransaction transaction;

  ImportError({
    required this.message,
    required this.transaction
  });
  factory ImportError.fromJson(Map<String, dynamic> json) {
    return ImportError(
      message: json['error'],
      transaction: ErrTransaction.fromJson(json['row']),
    );
  }
}

class SubmitFileResponse {
  final String status;
  final String message;
  final List<ImportError>? error;
  // final List<Transaction>? success;

  SubmitFileResponse({
    required this.status,
    required this.message,
    this.error,
    // this.success,
  });

  factory SubmitFileResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return SubmitFileResponse(
      status: json['status'],
      message: json['message'],
      error: data != null && data['errors'] != null
        ? (data['errors'] as List).map((item) => ImportError.fromJson(item)).toList()
        : [],
      // success: data != null && data['validTransactions'] != null
      //   ? (data['validTransactions'] as List).map((item) => Transaction.fromJson(item)).toList()
      //   : []
    );
  }
}

class ImportFileResponse {
  final String status;
  final String message;
  final String? path;

  ImportFileResponse({
    required this.status,
    required this.message,
    this.path
  });

  factory ImportFileResponse.fromJson(Map<String, dynamic> json) {
    return ImportFileResponse(
      status: json['status'],
      message: json['message'],
      path: json['data'] != null && json['data']['file'] != null ? json['data']['file']['path'] : ''
    );
  }
}
