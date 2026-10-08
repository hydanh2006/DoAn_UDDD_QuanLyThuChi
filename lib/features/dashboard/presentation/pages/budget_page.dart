import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/dashboard/data/models/transaction_model.dart';
import 'package:doan_appqlthuchi/features/dashboard/data/mock_data.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/widgets/add_transaction_dialog.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/widgets/add_budget_dialog.dart';

String getCategoryName(CategoryType type) {
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

class BudgetModel {
  final String id;
  final CategoryType category;
  final double limitAmount;
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final int warningPercent;

  BudgetModel({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.warningPercent,
  });
}

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  String _selectedTab = 'Tháng này';

  final List<BudgetModel> _budgets = [
    BudgetModel(
      id: '1',
      category: CategoryType.Food,
      limitAmount: 1000000,
      period: 'Hàng tháng',
      startDate: DateTime(2026, 10, 1),
      endDate: DateTime(2026, 10, 31),
      warningPercent: 80,
    ),
  ];

  double _calculateSpentAmount(CategoryType category) {
    return mockTransactions
        .where((tx) => !tx.isIncome && tx.category == category)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  void _showAddBudgetDialog({BudgetModel? editBudget}) {
    showDialog(
      context: context,
      builder: (context) => AddBudgetDialog(budgetToEdit: editBudget),
    ).then((result) {
      if (result != null && result is BudgetModel) {
        setState(() {
          if (editBudget != null) {
            final index = _budgets.indexWhere((b) => b.id == result.id);
            if (index != -1) _budgets[index] = result;
          } else {
            _budgets.insert(0, result);
          }
        });
      }
    });
  }

  void _openAddTransactionDialog() async {
    final result = await showDialog<TransactionModel>(
      context: context,
      builder: (context) => const AddTransactionDialog(),
    );

    if (result != null) {
      setState(() {
        mockTransactions.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    double totalLimit = _budgets.fold(0.0, (sum, b) => sum + b.limitAmount);
    double totalSpent = _budgets.fold(
      0.0,
      (sum, b) => sum + _calculateSpentAmount(b.category),
    );
    double overallProgress = totalLimit > 0
        ? (totalSpent / totalLimit).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Expanded chỉ bao bọc Column chứa Text
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngân sách',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Đặt hạn mức chi tiêu cho từng danh mục và theo dõi mức đã dùng.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onPressed: () => _showAddBudgetDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm hạn mức'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildTabButton(
                  'Tuần này',
                  _selectedTab == 'Tuần này',
                  () => setState(() => _selectedTab = 'Tuần này'),
                ),
                const SizedBox(width: 12),
                _buildTabButton(
                  'Tháng này',
                  _selectedTab == 'Tháng này',
                  () => setState(() => _selectedTab = 'Tháng này'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tổng hạn mức',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatCurrency.format(totalLimit),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Đã chi',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatCurrency.format(totalSpent),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '% đã dùng',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(overallProgress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: overallProgress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    color: overallProgress > 0.8
                        ? Colors.red
                        : AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _budgets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final budget = _budgets[index];
                final spent = _calculateSpentAmount(budget.category);
                final progress = budget.limitAmount > 0
                    ? (spent / budget.limitAmount).clamp(0.0, 1.0)
                    : 0.0;
                final tempTx = TransactionModel(
                  id: '',
                  title: '',
                  amount: 0,
                  isIncome: false,
                  category: budget.category,
                  date: DateTime.now(),
                );

                return Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: tempTx.categoryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              tempTx.categoryIcon,
                              color: tempTx.categoryColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getCategoryName(budget.category),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Hạn mức: ${formatCurrency.format(budget.limitAmount)} • Ngưỡng ${budget.warningPercent}%',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatCurrency.format(spent),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}% đã dùng',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () =>
                                _showAddBudgetDialog(editBudget: budget),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.redAccent,
                            ),
                            onPressed: () =>
                                setState(() => _budgets.removeAt(index)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade200,
                        color: progress > (budget.warningPercent / 100)
                            ? Colors.red
                            : AppColors.primary,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _openAddTransactionDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text(
                    'Thêm chi phí',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
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
