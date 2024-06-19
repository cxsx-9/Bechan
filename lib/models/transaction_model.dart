
class Transaction {
  final int transactionsId;
  final int amount;
  final String note;
  final DateTime transactionDatetime;
  final String categorieName;
  final String categorieType;

  Transaction({
    required this.transactionsId,
    required this.amount,
    required this.note,
    required this.transactionDatetime,
    required this.categorieName,
    required this.categorieType,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionsId: json['transactions_id'],
      amount: json['amount'],
      note: json['note'],
      transactionDatetime: DateTime.parse(json['transaction_datetime']),
      categorieName: json['categorie_name'],
      categorieType: json['categorie_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions_id': transactionsId,
      'amount': amount,
      'note': note,
      'transaction_datetime': transactionDatetime.toIso8601String(),
      'categorie_name': categorieName,
      'categorie_type': categorieType,
    };
  }
}

class Summary {
  final int userId;
  final String selectedDate;
  final int totalIncome;
  final int totalExpense;

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
      totalIncome: json['total_income'],
      totalExpense: json['total_expense'],
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

class TscnResponse {
  final String status;
  final String message;
  final Summary? summary;
  final List<Transaction>? transactions;

  TscnResponse({
    required this.status,
    required this.message,
    this.summary,
    this.transactions,
  });

  factory TscnResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return TscnResponse(
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
