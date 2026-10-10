import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';

import '../../data/models/reminder_model.dart';

class ReminderItem extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMarkAsPaid;

  const ReminderItem({
    Key? key,
    required this.reminder,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkAsPaid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final formatDate = DateFormat('dd/MM/yyyy');

    Color statusColor;
    String statusText;
    Color statusBgColor;

    switch (reminder.status) {
      case ReminderStatus.paid:
        statusColor = Colors.green;
        statusText = 'Đã thanh toán';
        statusBgColor = Colors.green.withOpacity(0.1);
        break;
      case ReminderStatus.overdue:
        statusColor = Colors.red;
        statusText = 'Quá hạn';
        statusBgColor = Colors.red;
        break;
      case ReminderStatus.pending:
        statusColor = AppColors.primary;
        statusText = 'Chờ tới hạn';
        statusBgColor = AppColors.primary.withOpacity(0.1);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(reminder.icon, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nhắc ${formatDate.format(reminder.reminderDate)}\nĐến hạn ${formatDate.format(reminder.dueDate)}\n${reminder.frequency}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formatCurrency.format(reminder.amount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: reminder.status == ReminderStatus.overdue
                        ? Colors.white
                        : statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (reminder.status != ReminderStatus.paid)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onMarkAsPaid,
                  child: const Text(
                    'Đã thanh toán',
                    style: TextStyle(fontSize: 12),
                  ),
                ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: onEdit,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                    onPressed: onDelete,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
