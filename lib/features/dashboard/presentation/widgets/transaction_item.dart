
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

import 'package:intl/intl.dart';
class TransactionItem extends StatelessWidget {
  final String title;
  final String time;
  final double amount;
  final bool isIncome;
  final IconData icon;
  final Color iconBackgroundColor;

  const TransactionItem({
    Key? key,
    required this.title,
    required this.time,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.iconBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format số tiền (ví dụ: 50.000 đ)
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

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
          // Khối chứa Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              // Tự động đổi màu icon: Xanh nếu là thu nhập, Đỏ nếu là chi phí
              color: isIncome ? AppColors.income : AppColors.expense,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Khối Tiêu đề & Thời gian
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Khối hiển thị Số tiền
          Text(
            isIncome
                ? '+ ${formatCurrency.format(amount)}'
                : formatCurrency.format(amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // Màu tiền: Xanh nếu thu nhập, Đen đậm nếu chi phí
              color: isIncome ? AppColors.income : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
