import 'package:flutter/material.dart';

enum CategoryType { Food, Rent, Shopping, Salary, Entertainment, Other }

class TransactionModel {
  final String id;
  String title;
  double amount;
  bool isIncome; // true = Thu nhập, false = Chi phí
  CategoryType category;
  DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.date,
  });

  // Hàm lấy Icon
  IconData get categoryIcon {
    switch (category) {
      case CategoryType.Food:
        return Icons.fastfood;
      case CategoryType.Rent:
        return Icons.home;
      case CategoryType.Shopping:
        return Icons.shopping_bag;
      case CategoryType.Salary:
        return Icons.attach_money;
      case CategoryType.Entertainment:
        return Icons.movie;
      default:
        return Icons.category;
    }
  }

  // Hàm lấy màu cho Icon
  Color get categoryColor {
    switch (category) {
      case CategoryType.Food:
        return Colors.orange;
      case CategoryType.Rent:
        return Colors.blue;
      case CategoryType.Shopping:
        return Colors.purple;
      case CategoryType.Salary:
        return Colors.green;
      case CategoryType.Entertainment:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
