import 'package:flutter/material.dart';

class TransactionModel {
  final String title;
  final String time;
  final double amount;
  final IconData icon;
  final Color iconBackgroundColor;

  TransactionModel({
    required this.title,
    required this.time,
    required this.amount,
    required this.icon,
    required this.iconBackgroundColor,
  });
}

// Dữ liệu mẫu (Mock data)
List<TransactionModel> mockTransactions = [
  TransactionModel(
    title: 'Ăn uống',
    time: 'Hôm nay, 12:30 PM',
    amount: -50000,
    icon: Icons.restaurant,
    iconBackgroundColor: const Color(0xFFFF3B30).withOpacity(0.1),
  ),
  TransactionModel(
    title: 'Mua sắm',
    time: 'Hôm qua, 09:15 AM',
    amount: -300000,
    icon: Icons.shopping_bag,
    iconBackgroundColor: const Color(0xFF5E5CE6).withOpacity(0.1),
  ),
  TransactionModel(
    title: 'Lương',
    time: '01/10/2026',
    amount: 15000000,
    icon: Icons.monetization_on,
    iconBackgroundColor: const Color(0xFF34C759).withOpacity(0.1),
  ),
];
