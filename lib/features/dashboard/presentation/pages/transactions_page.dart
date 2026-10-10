import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/dashboard/data/models/transaction_model.dart';
import 'package:doan_appqlthuchi/features/dashboard/data/mock_data.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/widgets/add_transaction_dialog.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';

  // Hàm mở Dialog thêm giao dịch
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

  // Hàm mở Dialog chỉnh sửa giao dịch
  void _openEditTransactionDialog(TransactionModel transaction) async {
    final result = await showDialog<TransactionModel>(
      context: context,
      builder: (context) =>
          AddTransactionDialog(transactionToEdit: transaction),
    );

    if (result != null) {
      setState(() {
        final index = mockTransactions.indexWhere((tx) => tx.id == result.id);
        if (index != -1) {
          mockTransactions[index] = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    // Lọc giao dịch theo tìm kiếm và bộ lọc (Tất cả / Thu nhập / Chi phí)
    final filteredTransactions = mockTransactions.where((tx) {
      final matchesSearch = tx.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      if (_selectedFilter == 'Tất cả') return matchesSearch;
      if (_selectedFilter == 'Thu nhập') return tx.isIncome && matchesSearch;
      if (_selectedFilter == 'Chi phí') return !tx.isIncome && matchesSearch;
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Giao dịch',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Xem, tìm kiếm và quản lý mọi khoản thu chi của bạn.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Ô tìm kiếm & Bộ lọc
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Tìm theo tên khoản...',
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

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Tất cả'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Thu nhập'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Chi phí'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: filteredTransactions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(48.0),
                      child: Center(
                        child: Text(
                          'Không tìm thấy giao dịch nào.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTransactions.length,
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.grey.shade100, height: 1),
                      itemBuilder: (context, index) {
                        final tx = filteredTransactions[index];
                        final dateStr = DateFormat('dd/MM/yyyy')
                            .format(tx.date);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon giao dịch
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: tx.categoryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  tx.categoryIcon,
                                  color: tx.categoryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow
                                          .ellipsis, // Cắt bớt nếu quá dài
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$dateStr • Tiền mặt • ${_getCategoryName(tx.category)}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Số tiền & Loại (Thu/Chi)
                              Text(
                                '${tx.isIncome ? '+' : '-'} ${formatCurrency.format(tx.amount)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: tx.isIncome
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Nút Sửa & Xóa
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () =>
                                        _openEditTransactionDialog(tx),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        mockTransactions.removeWhere(
                                          (item) => item.id == tx.id,
                                        );
                                      });
                                    },
                                  ),
                                ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransactionDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

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

  Widget _buildFilterChip(String title) {
    final isSelected = _selectedFilter == title;
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      selectedColor: AppColors.primary.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = title);
        }
      },
    );
  }
}
