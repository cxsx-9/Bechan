class Category {
  final int categorieId;
  final String name;
  final int? userId;

  Category({
    required this.categorieId,
    required this.name,
    this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categorieId: json['categorie_id'],
      name: json['name'],
      userId: json['user_id'],
    );
  }
}

class CategoriesResponse {
  String status;
  String message;
  List<Category> income;
  List<Category> expenses;
  // List<Category> tag;

  CategoriesResponse({
    String ? status,
    String ? message,
    List<Category> ? income,
    List<Category> ? expenses,
    // List<Category> ? tag,
  }) :
    status = status ?? '',
    message = message ?? '',
    income = income ?? [],
    expenses = expenses ?? []
    // tag = tag ?? []
  ;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    var incomeList = json['data']['income'] as List;
    var expensesList = json['data']['expenses'] as List;
    // var tagList = json['data']['tag'] as List;

    List<Category> income = incomeList.map((i) => Category.fromJson(i)).toList();
    List<Category> expenses = expensesList.map((i) => Category.fromJson(i)).toList();
    // List<Category> tag = tagList.map((i) => Category.fromJson(i)).toList();

    return CategoriesResponse(
      status: json['status'],
      message: json['message'],
      income: income,
      expenses: expenses,
      // tag: tag,
    );
  }
}
