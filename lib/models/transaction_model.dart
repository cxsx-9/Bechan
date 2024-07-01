
import 'package:bechan/models/tag_model.dart';

class Transaction {
  final int transactionsId;
  final double amount;
  final String note;
  final DateTime transactionDatetime;
  final int categorieId;
  final String categorieName;
  final String categorieType;
  final int fav;
  final List<Tag> tags;

  Transaction({
    required this.transactionsId,
    required this.amount,
    required this.note,
    required this.transactionDatetime,
    required this.categorieId,
    required this.categorieName,
    required this.categorieType,
    required this.fav,
    required this.tags,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    var data = json['tags'];
    return Transaction(
      transactionsId: json['transactions_id'],
      amount: json['amount'].toDouble(),
      note: json['note'],
      transactionDatetime: DateTime.parse(json['transaction_datetime']),
      categorieId: json['categorie_id'],
      categorieName: json['categorie_name'],
      categorieType: json['categorie_type'],
      fav: json['fav'],
      tags: data != [] ? (data as List).map((tags)=> Tag.fromJson(tags)).toList() : []
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions_id': transactionsId,
      'amount': amount,
      'note': note,
      'transaction_datetime': transactionDatetime.toIso8601String(),
      'categorie_id': categorieId,
      'categorie_name': categorieName,
      'categorie_type': categorieType,
      'fav': categorieName,
    };
  }
}

class Summary {
  final int userId;
  final String selectedDate;
  final double totalIncome;
  final double totalExpense;

  Summary({
    required this.userId,
    required this.selectedDate,
    required this.totalIncome,
    required this.totalExpense,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      userId: json['user_id'],
      selectedDate: json['selected_date'],
      totalIncome: json['total_income'].toDouble(),
      totalExpense: json['total_expense'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'selected_date': selectedDate,
      'total_income': totalIncome,
      'total_expense': totalExpense,
    };
  }
}

class TransactionResponse {
  final String status;
  final String message;
  final Summary? summary;
  final List<Transaction>? transactions;

  TransactionResponse({
    required this.status,
    required this.message,
    this.summary,
    this.transactions,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return TransactionResponse(
      status: json['status'],
      message: json['message'],
      summary: data != null && data['summary'] != null ? Summary.fromJson(data['summary']) : null,
      transactions: data != null && data['transactions'] != null
          ? (data['transactions'] as List).map((transaction) => Transaction.fromJson(transaction)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'summary': summary?.toJson(),
      'transactions': transactions?.map((transaction) => transaction.toJson()).toList(),
    };
  }
}
