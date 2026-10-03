import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format số tiền (ví dụ: -50,000)
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final isIncome = transaction.amount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: transaction.iconBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              transaction.icon,
              color: isIncome ? AppColors.income : (transaction.amount == -300000 ? AppColors.primary : AppColors.expense), // Logic màu tạm thời theo mock data
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Tiêu đề & Thời gian
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.time,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Số tiền
          Text(
            isIncome ? '+ ${formatCurrency.format(transaction.amount)}' : formatCurrency.format(transaction.amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isIncome ? AppColors.income : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}