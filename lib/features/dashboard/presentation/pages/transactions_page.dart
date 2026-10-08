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
  final TextEditingController _searchController = TextEditingController();

  // Các bộ lọc
  String _searchQuery = '';
  String _typeFilter = 'Tất cả';
  String _timeFilter = 'Tất cả';
  String _categoryFilter = 'Tất cả danh mục';

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

  // Hàm xóa giao dịch
  void _deleteTransaction(String id) {
    setState(() {
      mockTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  // Hàm chỉnh sửa giao dịch
  void _openEditTransactionDialog(TransactionModel transaction) async {
    final result = await showDialog<TransactionModel>(
      context: context,
      builder: (context) =>
          AddTransactionDialog(transactionToEdit: transaction),
    );

    if (result != null) {
      setState(() {
        // Tìm vị trí giao dịch cũ trong danh sách và thay thế bằng giao dịch mới
        final index = mockTransactions.indexWhere((tx) => tx.id == result.id);
        if (index != -1) {
          mockTransactions[index] = result;
        }
      });
    }
  }

  // Lọc danh sách giao dịch
  List<TransactionModel> get _filteredTransactions {
    return mockTransactions.where((tx) {
      // Lọc theo từ khóa tìm kiếm
      final matchesSearch = tx.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      // Lọc theo loại (Thu nhập / Chi phí)
      bool matchesType = true;
      if (_typeFilter == 'Thu nhập') {
        matchesType = tx.isIncome;
      } else if (_typeFilter == 'Chi phí') {
        matchesType = !tx.isIncome;
      }

      // Lọc theo thời gian đơn giản
      bool matchesTime = true;
      final now = DateTime.now();
      if (_timeFilter == 'Hôm nay') {
        matchesTime =
            tx.date.year == now.year &&
            tx.date.month == now.month &&
            tx.date.day == now.day;
      } else if (_timeFilter == 'Tuần này') {
        // Kiểm tra trong vòng 7 ngày gần nhất
        matchesTime = now.difference(tx.date).inDays <= 7;
      } else if (_timeFilter == 'Tháng này') {
        matchesTime = tx.date.year == now.year && tx.date.month == now.month;
      }

      return matchesSearch && matchesType && matchesTime;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final transactions = _filteredTransactions;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header & Nút thêm giao dịch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  onPressed: _openAddTransactionDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm giao dịch'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Thanh tìm kiếm và các bộ lọc
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ô tìm kiếm
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Tìm theo tên khoản...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Các nút lọc ngang
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          'Tất cả',
                          _typeFilter == 'Tất cả',
                          () => setState(() => _typeFilter = 'Tất cả'),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Thu nhập',
                          _typeFilter == 'Thu nhập',
                          () => setState(() => _typeFilter = 'Thu nhập'),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Chi phí',
                          _typeFilter == 'Chi phí',
                          () => setState(() => _typeFilter = 'Chi phí'),
                        ),

                        const SizedBox(width: 16),
                        Container(
                          height: 24,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 16),

                        _buildFilterChip(
                          'Tất cả',
                          _timeFilter == 'Tất cả',
                          () => setState(() => _timeFilter = 'Tất cả'),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Hôm nay',
                          _timeFilter == 'Hôm nay',
                          () => setState(() => _timeFilter = 'Hôm nay'),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Tuần này',
                          _timeFilter == 'Tuần này',
                          () => setState(() => _timeFilter = 'Tuần này'),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Tháng này',
                          _timeFilter == 'Tháng này',
                          () => setState(() => _timeFilter = 'Tháng này'),
                        ),

                        const SizedBox(width: 16),
                        Container(
                          height: 24,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 16),

                        // Dropdown danh mục
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: _categoryFilter,
                            underline: const SizedBox(),
                            items:
                                [
                                      'Tất cả danh mục',
                                      'Ăn uống',
                                      'Tiền nhà',
                                      'Mua sắm',
                                      'Giải trí',
                                    ]
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              if (val != null)
                                setState(() => _categoryFilter = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Danh sách hiển thị giao dịch
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: transactions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          'Không có giao dịch nào phù hợp.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.grey.shade200, height: 1),
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final formattedDate =
                            "${DateFormat('dd/MM/yyyy').format(tx.date)} • Tiền mặt • ${tx.category.name}";

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: tx.categoryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  tx.categoryIcon,
                                  color: tx.categoryColor,
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
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                tx.isIncome
                                    ? '+ ${formatCurrency.format(tx.amount)}'
                                    : formatCurrency.format(tx.amount),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: tx.isIncome
                                      ? AppColors.income
                                      : AppColors.expense,
                                ),
                              ),
                              const SizedBox(width: 24),

                              // Nút Sửa & Xóa
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                onPressed: () => _openEditTransactionDialog(tx),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _deleteTransaction(tx.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: null,
                  child: const Text('Trang trước'),
                ),
                const Text(
                  'Trang 1/1',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                OutlinedButton(onPressed: null, child: const Text('Trang sau')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget nút Chip lọc
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
