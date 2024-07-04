class SummaryY {
  int userId;
  String year;
  double totalIncome;
  double totalExpense;
  double balance;

  SummaryY({
    this.userId = 0,
    this.year = '',
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.balance = 0.0,
  });

  factory SummaryY.fromJson(Map<String, dynamic> json) {
    return SummaryY(
      userId: json['user_id'] ?? 0,
      year: json['year'] ?? '',
      totalIncome: json['total_income'].toDouble() ?? 0.0,
      totalExpense: json['total_expense'].toDouble() ?? 0.0,
      balance: json['balance'].toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'year': year,
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'balance': balance,
    };
  }

  @override
  String toString() {
    return 'SummaryY{userId: $userId, year: $year, totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance}';
  }
}

class MonthData {
  int month;
  double totalIncome;
  double totalExpense;
  double balance;

  MonthData({
    this.month = 0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.balance = 0.0,  
  });

  factory MonthData.fromJson(Map<String, dynamic> json) {
    return MonthData(
      month: json['month'] ?? '',
      totalIncome: json['total_income'].toDouble() ?? 0.0,
      totalExpense: json['total_expense'].toDouble() ?? 0.0,
      balance: json['balance'].toDouble() ?? 0.0,
    );
  }
}

class SumYearResponse {
  String? status;
  String? message;
  SummaryY? summary;
  List<MonthData>? months;

  SumYearResponse({
    this.status,
    this.message,
    this.summary,
    this.months,
  });

  factory SumYearResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return SumYearResponse(
      status: json['status'],
      message: json['message'],
      summary: data != null && data['summary'] != null
          ? SummaryY.fromJson(data['summary'])
          : SummaryY(),
      months: data != null && data['monthly_summary'] != null
          ? (data['monthly_summary'] as List)
              .map((item) => MonthData.fromJson(item))
              .toList()
          : [],
    );
  }
  List<dynamic> getCategories(String a) { return [];}
}
