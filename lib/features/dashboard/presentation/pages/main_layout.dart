import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'dashboard_page.dart';

import 'package:doan_appqlthuchi/features/dashboard/presentation/pages/transactions_page.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/pages/budget_page.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/pages/savings_page.dart';
import 'package:doan_appqlthuchi/features/reminder/presentation/pages/reminder_page.dart';
import 'package:doan_appqlthuchi/features/profile/presentation/pages/profile_page.dart';
import 'package:doan_appqlthuchi/features/notifications/presentation/pages/notifications_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    DashboardPage(
      onNavigate: (index) {
        _onMenuTapped(index);
      },
    ),
    const SavingsPage(),
    const ReminderPage(),
    const NotificationsPage(),
    const ProfilePage(),
    const TransactionsPage(),
    const BudgetPage(),
  ];

  void _onMenuTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  Widget _buildMenuContent() {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'M',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Moni',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildMenuItem(0, Icons.dashboard_outlined, 'Tổng quan'),
          _buildMenuItem(1, Icons.savings_outlined, 'Tiết kiệm'),
          _buildMenuItem(2, Icons.notifications_active_outlined, 'Nhắc nhở'),
          _buildMenuItem(3, Icons.notifications_none_outlined, 'Thông báo'),
          _buildMenuItem(4, Icons.person_outline, 'Hồ sơ'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String title) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onMenuTapped(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
              title: const Text(
                'Moni',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      drawer: isDesktop ? null : Drawer(child: _buildMenuContent()),

      body: Row(
        children: [
          if (isDesktop)
            Row(
              children: [
                _buildMenuContent(),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Colors.black12,
                ),
              ],
            ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}
