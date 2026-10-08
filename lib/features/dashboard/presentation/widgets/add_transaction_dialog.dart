import 'package:flutter/material.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/dashboard/data/models/transaction_model.dart';
import 'package:intl/intl.dart';

class AddTransactionDialog extends StatefulWidget {
  final TransactionModel?
  transactionToEdit; // Nếu có dữ liệu nghĩa là đang Sửa, ngược lại là Thêm mới

  const AddTransactionDialog({Key? key, this.transactionToEdit})
    : super(key: key);

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  late bool isExpenseSelected;
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime selectedDate;
  late CategoryType selectedCategory;
  String selectedPayment = 'Tiền mặt';

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      final tx = widget.transactionToEdit!;
      isExpenseSelected = !tx.isIncome;
      _titleController = TextEditingController(text: tx.title);
      _amountController = TextEditingController(
        text: tx.amount.toStringAsFixed(0),
      );
      selectedDate = tx.date;
      selectedCategory = tx.category;
    } else {
      isExpenseSelected = true;
      _titleController = TextEditingController();
      _amountController = TextEditingController();
      selectedDate = DateTime.now();
      selectedCategory = CategoryType.Food;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickCustomDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final List<CategoryType> categories = [
    CategoryType.Food,
    CategoryType.Rent,
    CategoryType.Shopping,
    CategoryType.Salary,
    CategoryType.Entertainment,
    CategoryType.Other,
  ];

  String _getCategoryName(CategoryType type) {
    switch (type) {
      case CategoryType.Food:
        return 'Ăn uống';
      case CategoryType.Rent:
        return 'Tiền nhà';
      case CategoryType.Shopping:
        return 'Mua sắm';
      case CategoryType.Salary:
        return 'Lương';
      case CategoryType.Entertainment:
        return 'Giải trí';
      case CategoryType.Other:
        return 'Khác';
    }
  }

  final List<String> payments = [
    'Tiền mặt',
    'Thẻ ngân hàng',
    'Ví MoMo',
    'Chuyển khoản',
  ];

  @override
  Widget build(BuildContext context) {
    final formattedInputDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final isEditing = widget.transactionToEdit != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        width: 650.0,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing
                        ? 'Chỉnh sửa giao dịch'
                        : (isExpenseSelected
                              ? 'Thêm chi phí'
                              : 'Thêm thu nhập'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Loại Thu / Chi
              Row(
                children: [
                  Expanded(
                    child: _buildTypeCard(
                      title: 'Thu nhập',
                      isSelected: !isExpenseSelected,
                      onTap: () => setState(() => isExpenseSelected = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeCard(
                      title: 'Chi phí',
                      isSelected: isExpenseSelected,
                      onTap: () => setState(() => isExpenseSelected = true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Ngày giao dịch
              const Text(
                'Ngày giao dịch',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickCustomDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(text: formattedInputDate),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today, size: 18),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
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
              const SizedBox(height: 16),

              // Tiêu đề
              const Text(
                'Tiêu đề',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ví dụ: Cơm tấm, Lương tháng 10',
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

              // Số tiền
              const Text(
                'Số tiền',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
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

              // Danh mục
              const Text(
                'Danh mục',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((catModel) {
                  final isSelected = selectedCategory == catModel;
                  final tempTransaction = TransactionModel(
                    id: '',
                    title: '',
                    amount: 0,
                    isIncome: false,
                    category: catModel,
                    date: DateTime.now(),
                  );

                  return ChoiceChip(
                    avatar: Icon(
                      tempTransaction.categoryIcon,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : tempTransaction.categoryColor,
                    ),
                    label: Text(_getCategoryName(catModel)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() => selectedCategory = catModel);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Phương thức thanh toán
              const Text(
                'Phương thức thanh toán',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: payments.map((method) {
                  final isSelected = selectedPayment == method;
                  return ChoiceChip(
                    avatar: Icon(
                      Icons.payment,
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                    label: Text(method),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() => selectedPayment = method);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Nút Lưu / Cập nhật
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        final titleText = _titleController.text.trim();
                        final amountValue =
                            double.tryParse(_amountController.text.trim()) ??
                            0.0;

                        final transactionId = isEditing
                            ? widget.transactionToEdit!.id
                            : DateTime.now().millisecondsSinceEpoch.toString();

                        final resultTransaction = TransactionModel(
                          id: transactionId,
                          title: titleText.isEmpty ? 'Giao dịch' : titleText,
                          amount: amountValue,
                          isIncome: !isExpenseSelected,
                          category: selectedCategory,
                          date: selectedDate,
                        );

                        Navigator.of(context).pop(resultTransaction);
                      },
                      child: Text(
                        isEditing ? 'CẬP NHẬT GIAO DỊCH' : 'THÊM GIAO DỊCH',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
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

  Widget _buildTypeCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
