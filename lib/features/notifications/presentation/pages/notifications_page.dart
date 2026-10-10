import 'package:flutter/material.dart';
import 'package:doan_appqlthuchi/features/notifications/data/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Quản lý trạng thái (State)
  int selectedTabIndex = 0; // 0: Tất cả, 1: Chưa đọc

  // Dữ liệu mẫu
  List<NotificationModel> notifications = [
    NotificationModel(
      title: "Giao dịch thành công",
      time: "8 giờ trước",
      content: "Bạn đã thu 7.000.000đ cho Luong",
      icon: Icons.swap_horiz,
      isRead: false,
    ),
    NotificationModel(
      title: "Giao dịch thành công",
      time: "16 giờ trước",
      content: "Bạn đã chi 7.000.000đ cho tien nha",
      icon: Icons.swap_horiz,
      isRead: true,
    ),
    NotificationModel(
      title: "Sắp đến hạn thanh toán",
      time: "1 ngày trước",
      content: "Hóa đơn Trả góp xe 200.000đ đến hạn vào 14/10/2026",
      icon: Icons.notifications_active,
      isRead: false,
    ),
    NotificationModel(
      title: "Giao dịch thành công",
      time: "1 ngày trước",
      content: "Bạn đã chi 20.000đ cho Ăn vặt",
      icon: Icons.swap_horiz,
      isRead: true,
    ),
  ];

  // Hàm lọc dữ liệu theo Tab
  List<NotificationModel> get displayedNotifications {
    if (selectedTabIndex == 0) {
      return notifications;
    } else {
      return notifications.where((n) => !n.isRead).toList();
    }
  }

  // Hàm đánh dấu tất cả đã đọc
  void markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 800;
          final double pad = isWide ? 32.0 : 16.0;

          final markAllButton = OutlinedButton.icon(
            onPressed: markAllAsRead,
            icon: const Icon(Icons.check, size: 18),
            label: const Text("Đánh dấu tất cả đã đọc"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );

          final titleBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thông báo",
                style: TextStyle(
                  fontSize: isWide ? 28 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Cập nhật về giao dịch, hóa đơn đến hạn và mục tiêu tiết kiệm.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          );

          return Padding(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header và nút hành động
                if (isWide)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: titleBlock),
                      const SizedBox(width: 16),
                      markAllButton,
                    ],
                  )
                else
                  // Điện thoại: nút nằm dưới tiêu đề
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleBlock,
                      const SizedBox(height: 16),
                      markAllButton,
                    ],
                  ),
                SizedBox(height: isWide ? 24 : 16),

                // Bộ lọc Tabs
                Row(
                  children: [
                    _buildTab("Tất cả", 0),
                    const SizedBox(width: 8),
                    _buildTab("Chưa đọc", 1),
                  ],
                ),
                SizedBox(height: isWide ? 24 : 16),

                // Khung chứa Danh sách hoặc Empty State
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade50.withOpacity(0.3),
                    ),
                    child: displayedNotifications.isEmpty
                        ? _buildEmptyState()
                        : _buildNotificationList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget tạo Tab lọc
  Widget _buildTab(String title, int index) {
    bool isActive = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blue.shade700 : Colors.grey.shade600,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Widget hiển thị Danh sách thông báo
  Widget _buildNotificationList() {
    return ListView.separated(
      itemCount: displayedNotifications.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final note = displayedNotifications[index];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon thông báo
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(note.icon, color: Colors.grey.shade700),
              ),
              const SizedBox(width: 16),
              // Nội dung thông báo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            fontWeight: note.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          note.time,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.content,
                      style: TextStyle(
                        color: note.isRead
                            ? Colors.grey.shade600
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (!note.isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 6),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Widget hiển thị khi không có dữ liệu
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.blueGrey.shade200,
            ),
            const SizedBox(height: 24),
            const Text(
              "Không có thông báo chưa đọc",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Khi có thông báo mới chưa đọc, chúng sẽ xuất hiện tại đây.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
