import 'package:flutter/material.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/reminder/data/models/reminder_model.dart';
import 'package:doan_appqlthuchi/features/reminder/presentation/widgets/add_reminder_dialog.dart';
import 'package:doan_appqlthuchi/features/reminder/presentation/widgets/reminder_item.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  String _selectedTab = 'Tất cả';

  // Dữ liệu giả lập
  List<ReminderModel> _reminders = [
    ReminderModel(
      id: '1',
      title: 'Học phí',
      amount: 10000000,
      frequency: 'Một lần',
      reminderDate: DateTime(2026, 9, 1),
      dueDate: DateTime(2026, 9, 30),
      status: ReminderStatus.overdue,
    ),
    ReminderModel(
      id: '2',
      title: 'Internet',
      amount: 200000,
      frequency: 'Hàng tháng',
      reminderDate: DateTime(2026, 10, 9),
      dueDate: DateTime(2026, 10, 9),
      status: ReminderStatus.pending,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Cập nhật trạng thái "Quá hạn" tự động mỗi khi mở trang
    for (var r in _reminders) {
      r.updateStatusBasedOnDate();
    }
  }

  void _openAddReminderDialog([ReminderModel? editItem]) async {
    final result = await showDialog<ReminderModel>(
      context: context,
      builder: (context) => AddReminderDialog(reminderToEdit: editItem),
    );

    if (result != null) {
      setState(() {
        if (editItem != null) {
          final idx = _reminders.indexWhere((e) => e.id == result.id);
          if (idx != -1) _reminders[idx] = result;
        } else {
          _reminders.insert(0, result);
        }
      });
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Bạn chắc chắn muốn xóa nhắc nhở này?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text('Lịch nhắc sẽ bị xóa khỏi danh sách của bạn.'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() => _reminders.removeWhere((r) => r.id == id));
              Navigator.pop(ctx);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _markAsPaid(String id) {
    setState(() {
      final idx = _reminders.indexWhere((r) => r.id == id);
      if (idx != -1) _reminders[idx].status = ReminderStatus.paid;
    });

    // Hiện SnackBar ở góc dưới
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.black87),
            SizedBox(width: 8),
            Text(
              'Đã ghi nhận thanh toán.',
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        width: 300,
      ),
    );
  }

  List<ReminderModel> get _filteredReminders {
    if (_selectedTab == 'Tất cả') return _reminders;
    if (_selectedTab == 'Chờ tới hạn')
      return _reminders
          .where((r) => r.status == ReminderStatus.pending)
          .toList();
    if (_selectedTab == 'Đã thanh toán')
      return _reminders.where((r) => r.status == ReminderStatus.paid).toList();
    if (_selectedTab == 'Quá hạn')
      return _reminders
          .where((r) => r.status == ReminderStatus.overdue)
          .toList();
    return _reminders;
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredReminders;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
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
                        'Nhắc nhở',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Các hóa đơn định kỳ sắp tới và ngày đến hạn.',
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
                  onPressed: () => _openAddReminderDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Đặt lịch nhắc'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Tất cả', 'Chờ tới hạn', 'Đã thanh toán', 'Quá hạn']
                    .map((tab) {
                      final isSelected = _selectedTab == tab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () => setState(() => _selectedTab = tab),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Danh sách
            if (_reminders.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 64),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bạn chưa có nhắc nhở nào.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hãy đặt lịch cho hóa đơn định kỳ.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _openAddReminderDialog(),
                      child: const Text('Đặt lịch nhắc'),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final reminder = list[index];
                  return ReminderItem(
                    reminder: reminder,
                    onEdit: () => _openAddReminderDialog(reminder),
                    onDelete: () => _confirmDelete(reminder.id),
                    onMarkAsPaid: () => _markAsPaid(reminder.id),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
