class SummaryM {
  int userId;
  String month;
  double totalIncome;
  double totalExpense;
  double balance;

  SummaryM({
    this.userId = 0,
    this.month = '',
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.balance = 0.0,
  });

  factory SummaryM.fromJson(Map<String, dynamic> json) {
    return SummaryM(
      userId: json['user_id'] ?? 0,
      month: json['month'] ?? '',
      totalIncome: json['total_income'].toDouble() ?? 0.0,
      totalExpense: json['total_expense'].toDouble() ?? 0.0,
      balance: json['balance'].toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'month': month,
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'balance': balance,
    };
  }

  @override
  String toString() {
    return 'SummaryM{userId: $userId, year: $month, totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance}';
  }
}

class SumCategory {
  int categorieId;
  String name;
  double amount;

  SumCategory({
    this.categorieId = 0,
    this.name = '',
    this.amount = 0.0,
  });

  factory SumCategory.fromJson(Map<String, dynamic> json) {
    return SumCategory(
      categorieId: json['categorie_id'] ?? 0,
      name: json['categorie_name'] ?? '',
      amount: json['amount'].runtimeType == "double" ? json['amount'] : json['amount'].toDouble(),
    );
  }
}

class SumTags {
  int tagId;
  String name;
  double income;
  double expense;

  SumTags({
    this.tagId = 0,
    this.name = '',
    this.income = 0.0,
    this.expense = 0.0,
  });

  factory SumTags.fromJson(Map<String, dynamic> json) {
    return SumTags(
      tagId: json['tag_id'] ?? 0,
      name: json['tag_name'] ?? '',
      income: json['income'].runtimeType == "double" ? json['income'] : json['income'].toDouble(),
      expense: json['expense'].runtimeType == "double" ? json['expense'] : json['expense'].toDouble(),
    );
  }
}

class SumType {
  String type;
  List<SumCategory>? categories;

  SumType({
    this.type = '',
    this.categories
  });

  factory SumType.fromJson(Map<String, dynamic> json) {
    var data = json['categories'] ?? '';
    return SumType(
      type: json['type'] ?? '',
      categories: data != null ? (data as List).map((item) => SumCategory.fromJson(item)).toList()
      : [],
    );
  }
}

class SumMonthResponse {
  String? status;
  String? message;
  SummaryM? summary;
  List<SumType>? summaryType;
  List<SumTags>? summaryTags;

  SumMonthResponse({
    this.status,
    this.message,
    this.summary,
    this.summaryType,
    this.summaryTags,
  });

  factory SumMonthResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return SumMonthResponse(
      status: json['status'],
      message: json['message'],
      summary: data != null && data['summary'] != null
          ? SummaryM.fromJson(data['summary'])
          : SummaryM(),
      summaryType: data != null && data['summary_type'] != null
          ? (data['summary_type'] as List)
              .map((item) => SumType.fromJson(item))
              .toList()
          : [],
      summaryTags: data != null && data['tag_summary'] != null
          ? (data['tag_summary'] as List)
              .map((item) => SumTags.fromJson(item))
              .toList()
          : [],
    );
  }
  List<SumCategory> getCategories(String category) {
    if (summaryType != []) {
      for (var type in summaryType!) {
        if (type.type == category) {
          return (type.categories!);
        }
      }
    }
    return [];
  }
}
