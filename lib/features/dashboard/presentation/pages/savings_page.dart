import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/widgets/add_goal_dialog.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/widgets/deposit_dialog.dart';

class SavingDepositModel {
  final double amount;
  final DateTime date;
  final String note;

  SavingDepositModel({
    required this.amount,
    required this.date,
    required this.note,
  });
}

class SavingGoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final String period;
  final DateTime endDate;
  double currentAmount;
  List<SavingDepositModel> history;

  SavingGoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.period,
    required this.endDate,
    this.currentAmount = 0.0,
    List<SavingDepositModel>? history,
  }) : history = history ?? [];
}

class SavingsPage extends StatefulWidget {
  const SavingsPage({Key? key}) : super(key: key);

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final List<SavingGoalModel> _goals = [
    SavingGoalModel(
      id: '1',
      title: 'dien thoai',
      targetAmount: 17000000,
      period: 'Hàng tháng',
      endDate: DateTime(2027, 1, 30),
      currentAmount: 500000,
      history: [
        SavingDepositModel(
          amount: 500000,
          date: DateTime(2026, 10, 8),
          note: 'Nạp lần đầu',
        ),
      ],
    ),
    SavingGoalModel(
      id: '2',
      title: 'xe máy',
      targetAmount: 1000000,
      period: 'Hàng tháng',
      endDate: DateTime(2027, 1, 15),
      currentAmount: 200000,
      history: [
        SavingDepositModel(
          amount: 200000,
          date: DateTime(2026, 10, 8),
          note: 'Nạp lần đầu',
        ),
      ],
    ),
  ];

  SavingGoalModel? _selectedGoalDetail;

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddGoalDialog(),
    ).then((newGoal) {
      if (newGoal != null && newGoal is SavingGoalModel) {
        setState(() {
          _goals.insert(0, newGoal);
        });
      }
    });
  }

  void _showDepositDialog(SavingGoalModel goal) {
    showDialog(
      context: context,
      builder: (context) => DepositDialog(goal: goal),
    ).then((depositAmount) {
      if (depositAmount != null &&
          depositAmount is double &&
          depositAmount > 0) {
        setState(() {
          goal.currentAmount += depositAmount;
          goal.history.insert(
            0,
            SavingDepositModel(
              amount: depositAmount,
              date: DateTime.now(),
              note: 'Nạp tiền tiết kiệm',
            ),
          );
        });
      }
    });
  }

  void _showEditGoalDialog(SavingGoalModel goal) {
    showDialog(
      context: context,
      builder: (context) => AddGoalDialog(goalToEdit: goal),
    ).then((updatedGoal) {
      if (updatedGoal != null && updatedGoal is SavingGoalModel) {
        setState(() {
          final index = _goals.indexWhere((g) => g.id == updatedGoal.id);
          if (index != -1) {
            _goals[index] = updatedGoal;
            _selectedGoalDetail = updatedGoal;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    if (_selectedGoalDetail != null) {
      return _buildGoalDetailView(_selectedGoalDetail!, formatCurrency);
    }

    double totalSaved = _goals.fold(0.0, (sum, g) => sum + g.currentAmount);
    double monthlyTargetSum = 4325000;
    double overallProgress = monthlyTargetSum > 0
        ? (totalSaved / monthlyTargetSum).clamp(0.0, 1.0)
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiết kiệm',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Theo dõi tiến độ các mục tiêu tiết kiệm của bạn.',
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
                  onPressed: _showAddGoalDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm mục tiêu'),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.savings_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tổng đã tiết kiệm',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatCurrency.format(totalSaved),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(height: 1),
                  ),
                  const Text(
                    'Đã tiết kiệm trong tháng',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: overallProgress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${formatCurrency.format(totalSaved)} / ${formatCurrency.format(monthlyTargetSum)} • ${(overallProgress * 100).toStringAsFixed(0)}% đạt mục tiêu tháng',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Mục tiêu của bạn',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: _goals.map((goal) {
                double progress = goal.targetAmount > 0
                    ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
                    : 0.0;
                String endDateStr = DateFormat('dd/MM/yyyy')
                    .format(goal.endDate);

                return Container(
                  width: 380,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade200,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${formatCurrency.format(goal.currentAmount)} / ${formatCurrency.format(goal.targetAmount)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hạn chót $endDateStr • ${goal.period}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () => _showDepositDialog(goal),
                            child: const Text('Nạp tiền'),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () =>
                                setState(() => _selectedGoalDetail = goal),
                            child: const Text(
                              'Chi tiết',
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalDetailView(
    SavingGoalModel goal,
    NumberFormat formatCurrency,
  ) {
    double progress = goal.targetAmount > 0
        ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
        : 0.0;
    String endDateStr = DateFormat('dd/MM/yyyy').format(goal.endDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _selectedGoalDetail = null),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Quay lại Tiết kiệm'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tiến độ mục tiêu',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Đã tiết kiệm ${formatCurrency.format(goal.currentAmount)} / ${formatCurrency.format(goal.targetAmount)}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cam kết mỗi chu kỳ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cần tiết kiệm 4.125.000đ mỗi tháng',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hạn chót',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              endDateStr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Định kỳ',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              goal.period,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Số lần nạp',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${goal.history.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => _showDepositDialog(goal),
                  child: const Text('Nạp tiền'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showEditGoalDialog(goal),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text(
                    'Sửa mục tiêu',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      _goals.removeWhere((g) => g.id == goal.id);
                      _selectedGoalDetail = null;
                    });
                  },
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Xóa mục tiêu'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Lịch sử nạp tiền',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: goal.history.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey.shade200, height: 1),
                itemBuilder: (context, index) {
                  final item = goal.history[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatCurrency.format(item.amount),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(item.date),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
