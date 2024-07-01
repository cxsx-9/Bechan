import 'package:bechan/models/tag_model.dart';

class Favourite {
  final int transactionsId;
  final double amount;
  final String note;
  final int categorieId;
  final String categorieName;
  final String categorieType;
  final int fav;
  final List<Tag> tags;

  Favourite({
    required this.transactionsId,
    required this.amount,
    required this.note,
    required this.categorieId,
    required this.categorieName,
    required this.categorieType,
    required this.fav,
    required this.tags,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    var data = json['tags'];
    return Favourite(
      transactionsId: json['transactions_id'],
      amount: json['amount'].toDouble(),
      note: json['note'],
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
      'categorie_id': categorieId,
      'categorie_name': categorieName,
      'categorie_type': categorieType,
      'fav': categorieName,
    };
  }
}

class FavouriteTransactionResposne {
  final String status;
  final String message;
  final List<Favourite>? favourite;

  FavouriteTransactionResposne({
    required this.status,
    required this.message,
    this.favourite
  });

  factory FavouriteTransactionResposne.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return FavouriteTransactionResposne(
      status: json['status'],
      message: json['message'],
      favourite: data != null && data['favorite'] != null ? (data['favorite'] as List).map((fav) => Favourite.fromJson(fav)).toList() : []
    );
  }
}