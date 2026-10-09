// ==========================================
// PHẦN 1: IMPORT CÁC THƯ VIỆN VÀ MÀN HÌNH
// ==========================================
import 'package:flutter/material.dart';

// Các màn hình từ các features (Vui lòng đảm bảo các file này tồn tại trong project)
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/notifications/presentation/notifications_page.dart';
import 'features/profile/presentation/profile_page.dart';

// ==========================================
// PHẦN 2: HÀM MAIN VÀ CẤU HÌNH APP CHÍNH
// ==========================================
void main() {
  runApp(const MonexApp());
}

class MonexApp extends StatelessWidget {
  const MonexApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monex - Quản Lý Chi Tiêu', // Kết hợp title từ cả 2 file
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter', // Lấy font Inter từ code 2
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Nền trắng từ code 1
      ),
      // Đặt MainShell làm khung giao diện chính của ứng dụng
      home: const MainShell(),
    );
  }
}

// ==========================================
// PHẦN 3: KHUNG CHÍNH (MAIN SHELL) - RESPONSIVE MENU
// ==========================================
class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Mặc định chọn tab 0 (Tổng quan / Dashboard)
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với menu
  final List<Widget> _pages = const [
    DashboardPage(), // Màn hình Tổng quan từ code 2
    Center(child: Text('Tiết kiệm')), // Placeholder
    Center(child: Text('Nhắc nhở')), // Placeholder
    NotificationsPage(), // Màn hình Thông báo từ code 1
    ProfilePage(), // Màn hình Hồ sơ từ code 1
  ];

  // Cấu hình các mục trong Menu (Sidebar / Drawer)
  final List<Map<String, dynamic>> _menuItems = const [
    {'title': 'Tổng quan', 'icon': Icons.home_outlined},
    {'title': 'Tiết kiệm', 'icon': Icons.savings_outlined},
    {'title': 'Nhắc nhở', 'icon': Icons.shield_outlined},
    {'title': 'Thông báo', 'icon': Icons.notifications_none},
    {'title': 'Hồ sơ', 'icon': Icons.person_outline},
  ];

  // ==========================================
  // PHẦN 4: WIDGET XÂY DỰNG MENU (DÙNG CHUNG)
  // ==========================================
  Widget _buildMenu({required bool closeOnTap}) {
    return Container(
      width: 240,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Header của Menu (Logo + Tên App)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'M',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Monex',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Render danh sách các nút điều hướng trong Menu
            for (int i = 0; i < _menuItems.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: ListTile(
                  selected: _selectedIndex == i,
                  selectedTileColor: Colors.blue.shade50,
                  selectedColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: Icon(_menuItems[i]['icon'] as IconData),
                  title: Text(_menuItems[i]['title'] as String),
                  onTap: () {
                    setState(() => _selectedIndex = i);
                    // Nếu đang dùng Drawer trên điện thoại thì đóng lại sau khi bấm
                    if (closeOnTap) Navigator.of(context).pop();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // PHẦN 5: RENDER GIAO DIỆN THEO KÍCH THƯỚC MÀN HÌNH
  // ==========================================
  @override
  Widget build(BuildContext context) {
    // Kiểm tra chiều rộng màn hình (Responsive)
    final bool isWide = MediaQuery.of(context).size.width >= 800;

    // --- TRƯỜNG HỢP 1: MÀN HÌNH RỘNG (Web, Desktop, Tablet ngang) ---
    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            _buildMenu(closeOnTap: false), // Sidebar cố định bên trái
            const VerticalDivider(width: 1), // Đường kẻ chia cắt
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: _pages),
            ),
          ],
        ),
      );
    }

    // --- TRƯỜNG HỢP 2: MÀN HÌNH HẸP (Điện thoại) ---
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          _menuItems[_selectedIndex]['title']
              as String, // Tiêu đề thay đổi theo tab
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        child: _buildMenu(closeOnTap: true),
      ), // Menu dạng Drawer kéo từ trái sang
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }
}
