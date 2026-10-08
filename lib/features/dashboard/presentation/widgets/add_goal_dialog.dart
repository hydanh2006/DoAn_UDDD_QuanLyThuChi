import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/pages/savings_page.dart';

class AddGoalDialog extends StatefulWidget {
  final SavingGoalModel? goalToEdit;

  const AddGoalDialog({Key? key, this.goalToEdit}) : super(key: key);

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  late TextEditingController _titleController;
  late TextEditingController _targetController;
  late String _selectedPeriod;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    if (widget.goalToEdit != null) {
      final g = widget.goalToEdit!;
      _titleController = TextEditingController(text: g.title);
      _targetController = TextEditingController(
        text: g.targetAmount.toStringAsFixed(0),
      );
      _selectedPeriod = g.period;
      _endDate = g.endDate;
    } else {
      _titleController = TextEditingController();
      _targetController = TextEditingController();
      _selectedPeriod = 'Hàng tháng';
      _endDate = DateTime.now().add(const Duration(days: 90));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final endDateStr = DateFormat('dd/MM/yyyy').format(_endDate);
    final isEditing = widget.goalToEdit != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 550,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Chỉnh sửa mục tiêu'
                          : 'Thêm mục tiêu tiết kiệm',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Tên mục tiêu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ví dụ: Xe đạp mới, iPhone 15 Pro, Quỹ dự phòng',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Số tiền mục tiêu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Định kỳ đóng góp',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPeriod,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items: ['Hàng tuần', 'Hàng tháng']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPeriod = val);
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Ngày hết hạn',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickEndDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(text: endDateStr),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today, size: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final title = _titleController.text.trim();
                      final target =
                          double.tryParse(_targetController.text.trim()) ?? 0.0;

                      // Giữ nguyên ID cũ nếu đang sửa, ngược lại tạo ID mới
                      final goalId = isEditing
                          ? widget.goalToEdit!.id
                          : DateTime.now().millisecondsSinceEpoch.toString();

                      final updatedGoal = SavingGoalModel(
                        id: goalId,
                        title: title.isEmpty ? 'Mục tiêu mới' : title,
                        targetAmount: target,
                        period: _selectedPeriod,
                        endDate: _endDate,
                        currentAmount: isEditing
                            ? widget.goalToEdit!.currentAmount
                            : 0.0,
                        history: isEditing ? widget.goalToEdit!.history : [],
                      );

                      Navigator.of(context).pop(updatedGoal);
                    },
                    child: Text(
                      isEditing ? 'CẬP NHẬT' : 'THÊM MỤC TIÊU',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
