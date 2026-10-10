import 'package:flutter/material.dart';

enum ReminderStatus { pending, paid, overdue }

class ReminderModel {
  final String id;
  final String title;
  final double amount;
  final String frequency;
  final DateTime reminderDate;
  final DateTime dueDate;
  final String? note;
  ReminderStatus status;

  ReminderModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.frequency,
    required this.reminderDate,
    required this.dueDate,
    this.note,
    this.status = ReminderStatus.pending,
  });

  // Lấy Icon dựa theo loại hóa đơn
  IconData get icon {
    switch (title) {
      case 'Thanh toán hóa đơn':
        return Icons.receipt_long;
      case 'Trả góp xe':
        return Icons.directions_car;
      case 'Tiền điện':
        return Icons.bolt;
      case 'Tiền nước':
        return Icons.water_drop;
      case 'Internet':
        return Icons.wifi;
      case 'Bảo hiểm':
        return Icons.shield;
      case 'Học phí':
        return Icons.school;
      default:
        return Icons.receipt;
    }
  }

  // Tự động kiểm tra nếu đã qua ngày mà chưa đóng thì chuyển thành Quá hạn
  void updateStatusBasedOnDate() {
    if (status != ReminderStatus.paid &&
        DateTime.now().isAfter(dueDate.add(const Duration(days: 1)))) {
      status = ReminderStatus.overdue;
    }
  }
}
