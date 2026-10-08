import 'package:flutter/material.dart';

import 'package:doan_appqlthuchi/features/dashboard/data/models/transaction_model.dart';

List<TransactionModel> mockTransactions = [
  TransactionModel(
    id: '1',
    title: 'lương',
    amount: 21000,
    isIncome: true,
    category: CategoryType.Food,
    date: DateTime(2026, 10, 8),
  ),
  TransactionModel(
    id: '2',
    title: 'cà phê',
    amount: 20000,
    isIncome: false,
    category: CategoryType.Food,
    date: DateTime(2026, 10, 8),
  ),
  TransactionModel(
    id: '3',
    title: 'luong thang',
    amount: 7000000,
    isIncome: true,
    category: CategoryType.Salary,
    date: DateTime(2026, 10, 8),
  ),
];

double calculateTotalIncome() {
  return mockTransactions
      .where((tx) => tx.isIncome)
      .fold(0.0, (sum, tx) => sum + tx.amount);
}

double calculateTotalExpense() {
  return mockTransactions
      .where((tx) => !tx.isIncome)
      .fold(0.0, (sum, tx) => sum + tx.amount);
}

double calculateCurrentBalance() {
  return calculateTotalIncome() - calculateTotalExpense();
}
