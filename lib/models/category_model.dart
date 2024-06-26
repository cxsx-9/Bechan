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
  List<Category> tag;

  CategoriesResponse({
    String ? status,
    String ? message,
    List<Category> ? income,
    List<Category> ? expenses,
    List<Category> ? tag,
  }) :
    status = status ?? '',
    message = message ?? '',
    income = income ?? [],
    expenses = expenses ?? [],
    tag = tag ?? []
  ;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    var incomeList = json['data']['income'] as List;
    var expensesList = json['data']['expenses'] as List;
    var tagList = json['data']['tag'] as List;

    List<Category> income = incomeList.map((i) => Category.fromJson(i)).toList();
    List<Category> expenses = expensesList.map((i) => Category.fromJson(i)).toList();
    List<Category> tag = tagList.map((i) => Category.fromJson(i)).toList();

    return CategoriesResponse(
      status: json['status'],
      message: json['message'],
      income: income,
      expenses: expenses,
      tag: tag,
    );
  }
}


// {
//     "status": "ok",
//     "message": "Get Categories Successfully",
//     "data": {
//         "income": [
//             {
//                 "categorie_id": 1,
//                 "name": "เงินเดือน",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 2,
//                 "name": "รายได้พิเศษ",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 3,
//                 "name": "รายได้จากการลงทุน",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 4,
//                 "name": "รายได้อื่นๆ",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 18,
//                 "name": "test_income",
//                 "user_id": 23
//             }
//         ],
//         "expenses": [
//             {
//                 "categorie_id": 5,
//                 "name": "อาหาร",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 6,
//                 "name": "สมัครสมาชิกรายเดือน",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 7,
//                 "name": "ช้อปปิ้ง",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 8,
//                 "name": "ค่าเดินทาง",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 9,
//                 "name": "ท่องเที่ยว",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 10,
//                 "name": "บิลและสาธารณูปโภค",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 11,
//                 "name": "ความบันเทิง",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 12,
//                 "name": "สุขภาพ",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 13,
//                 "name": "การศึกษา",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 14,
//                 "name": "การเงินการลงทุน",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 15,
//                 "name": "บริจาค",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 16,
//                 "name": "อื่นๆ",
//                 "user_id": null
//             },
//             {
//                 "categorie_id": 19,
//                 "name": "test_expense",
//                 "user_id": 23
//             }
//         ],
//         "tag": [
//             {
//                 "categorie_id": 20,
//                 "name": "test_tag",
//                 "user_id": 23
//             }
//         ]
//     }
// }