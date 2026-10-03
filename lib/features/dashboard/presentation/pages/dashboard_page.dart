// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_item.dart';
import '../../data/models/transaction_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Biến lưu trữ index của tab đang được chọn
  int _selectedIndex = 0;

  // Danh sách các Widget (màn hình) tương ứng với từng tab
  static const List<Widget> _widgetOptions = <Widget>[
    _DashboardContent(), // Tab 0: Trang chủ (Dashboard)
    Center(
      child: Text('Màn hình Thống kê', style: TextStyle(fontSize: 24)),
    ), // Tab 1: Thống kê
    Center(
      child: Text('Màn hình Ngân sách', style: TextStyle(fontSize: 24)),
    ), // Tab 2: Ngân sách
    Center(
      child: Text('Màn hình Tài khoản', style: TextStyle(fontSize: 24)),
    ), // Tab 3: Tài khoản
  ];

  // Hàm xử lý khi bấm vào icon trên BottomAppBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Hàm xử lý khi bấm nút "+"
  void _onAddTransactionPressed() {
    // Hiển thị một Dialog đơn giản làm ví dụ
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm Giao Dịch Mới'),
          content: const Text('Chức năng thêm giao dịch sẽ được mở tại đây.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng Dialog
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // Hiển thị màn hình tương ứng với _selectedIndex
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Thanh điều hướng đáy
      bottomNavigationBar: _buildBottomNavigationBar(),
      // Nút Thêm nổi bật
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTransactionPressed, // Gọi hàm xử lý
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Nút Home (Index 0)
          IconButton(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? AppColors.primary : Colors.grey,
            ),
            onPressed: () => _onItemTapped(0),
          ),
          // Nút Thống kê (Index 1)
          IconButton(
            icon: Icon(
              Icons.bar_chart,
              color: _selectedIndex == 1 ? AppColors.primary : Colors.grey,
            ),
            onPressed: () => _onItemTapped(1),
          ),
          const SizedBox(width: 48), // Khoảng trống cho FAB
          // Nút Ngân sách (Index 2)
          IconButton(
            icon: Icon(
              Icons.account_balance_wallet,
              color: _selectedIndex == 2 ? AppColors.primary : Colors.grey,
            ),
            onPressed: () => _onItemTapped(2),
          ),
          // Nút Profile (Index 3)
          IconButton(
            icon: Icon(
              Icons.person,
              color: _selectedIndex == 3 ? AppColors.primary : Colors.grey,
            ),
            onPressed: () => _onItemTapped(3),
          ),
        ],
      ),
    );
  }
}

// Chuyển phần nội dung cũ của Dashboard vào một Widget riêng để dễ quản lý
class _DashboardContent extends StatelessWidget {
  const _DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 32),

          // Thẻ số dư
          const BalanceCard(),
          const SizedBox(height: 40),

          // Tiêu đề danh sách giao dịch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Giao dịch gần đây',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Xử lý sự kiện "Xem tất cả"
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mở danh sách tất cả giao dịch...'),
                    ),
                  );
                },
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Danh sách giao dịch
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockTransactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(transaction: mockTransactions[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Chào buổi sáng,',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Danh!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
