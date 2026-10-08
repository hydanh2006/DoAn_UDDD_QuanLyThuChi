import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/dashboard/data/models/transaction_model.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/pages/budget_page.dart';

class AddBudgetDialog extends StatefulWidget {
  final BudgetModel? budgetToEdit;

  const AddBudgetDialog({Key? key, this.budgetToEdit}) : super(key: key);

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  late CategoryType _selectedCategory;
  late TextEditingController _amountController;
  late TextEditingController _warningController;
  String _selectedPeriod = 'Hàng tháng';
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    if (widget.budgetToEdit != null) {
      final b = widget.budgetToEdit!;
      _selectedCategory = b.category;
      _amountController = TextEditingController(text: b.limitAmount.toStringAsFixed(0));
      _warningController = TextEditingController(text: b.warningPercent.toString());
      _selectedPeriod = b.period;
      _startDate = b.startDate;
      _endDate = b.endDate;
    } else {
      _selectedCategory = CategoryType.Food;
      _amountController = TextEditingController();
      _warningController = TextEditingController(text: '80');
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 30));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _warningController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final startDateStr = DateFormat('dd/MM/yyyy').format(_startDate);
    final endDateStr = DateFormat('dd/MM/yyyy').format(_endDate);
    final isEditing = widget.budgetToEdit != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        width: 550.0,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Chỉnh sửa hạn mức' : 'Thêm hạn mức',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<CategoryType>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                items: CategoryType.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(getCategoryName(cat)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),
              const Text('Hạn mức (VND)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Kỳ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildPeriodButton('Hàng tuần', _selectedPeriod == 'Hàng tuần', () => setState(() => _selectedPeriod = 'Hàng tuần')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPeriodButton('Hàng tháng', _selectedPeriod == 'Hàng tháng', () => setState(() => _selectedPeriod = 'Hàng tháng')),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ngày bắt đầu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _pickDate(true),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: TextEditingController(text: startDateStr),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today, size: 16),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ngày kết thúc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _pickDate(false),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: TextEditingController(text: endDateStr),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today, size: 16),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Ngưỡng cảnh báo (%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _warningController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Hủy', style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
                      final warning = int.tryParse(_warningController.text.trim()) ?? 80;
                      final budgetId = isEditing ? widget.budgetToEdit!.id : DateTime.now().millisecondsSinceEpoch.toString();

                      final newBudget = BudgetModel(
                        id: budgetId,
                        category: _selectedCategory,
                        limitAmount: amount,
                        period: _selectedPeriod,
                        startDate: _startDate,
                        endDate: _endDate,
                        warningPercent: warning,
                      );

                      Navigator.of(context).pop(newBudget);
                    },
                    child: Text(isEditing ? 'CẬP NHẬT' : 'LƯU', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}