import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/dashboard/data/mock_data.dart';
import 'package:doan_appqlthuchi/features/dashboard/data/models/transaction_model.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/widgets/transaction_item.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/widgets/add_transaction_dialog.dart';

class DashboardPage extends StatefulWidget {
  final Function(int)? onNavigate;

  const DashboardPage({Key? key, this.onNavigate}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  void _showTransactionForm(BuildContext context) async {
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
    final double currentBalance = calculateCurrentBalance();
    final double totalIncome = calculateTotalIncome();
    final double totalExpense = calculateTotalExpense();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Tổng quan',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Xin chào, Danh',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),

            // Thẻ Tổng số dư
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Số dư hiện tại',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency.format(currentBalance),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.grey.shade200, height: 1),
                  const SizedBox(height: 24),

                  // Thống kê thu chi động
                  Wrap(
                    spacing: 32,
                    runSpacing: 16,
                    children: [
                      _buildSummaryItem(
                        icon: Icons.arrow_upward,
                        iconColor: Colors.green,
                        label: 'Tổng thu tháng này',
                        amount: formatCurrency.format(totalIncome),
                      ),
                      _buildSummaryItem(
                        icon: Icons.arrow_downward,
                        iconColor: Colors.red,
                        label: 'Tổng chi tháng này',
                        amount: formatCurrency.format(totalExpense),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Nút thao tác nhanh chuyển trang
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionBtn(
                    Icons.savings_outlined,
                    'Tiết kiệm',
                    () => widget.onNavigate?.call(1),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickActionBtn(
                    Icons.calendar_today_outlined,
                    'Nhắc nhở',
                    () => widget.onNavigate?.call(2),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickActionBtn(
                    Icons.pie_chart_outline,
                    'Ngân sách',
                    () => widget.onNavigate?.call(6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Giao dịch gần đây & Nút Thêm giao dịch
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 12,
              children: [
                const Text(
                  'Giao dịch gần đây',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Wrap(
                  spacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        widget.onNavigate?.call(5);
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _showTransactionForm(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Thêm giao dịch'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Danh sách giao dịch động
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mockTransactions.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey.shade200, height: 1),
                itemBuilder: (context, index) {
                  final tx = mockTransactions[index];
                  final formattedDate =
                      "${tx.date.day.toString().padLeft(2, '0')}/${tx.date.month.toString().padLeft(2, '0')}/${tx.date.year}";

                  return TransactionItem(
                    title: tx.title,
                    time: formattedDate,
                    amount: tx.amount,
                    isIncome: tx.isIncome,
                    icon: tx.categoryIcon,
                    iconBackgroundColor: tx.categoryColor.withValues(
                      alpha: 0.1,
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

  Widget _buildSummaryItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String amount,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: iconColor.withValues(alpha: 0.5)),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionBtn(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
