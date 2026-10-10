import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/reminder/data/models/reminder_model.dart';

class AddReminderDialog extends StatefulWidget {
  final ReminderModel? reminderToEdit;

  const AddReminderDialog({Key? key, this.reminderToEdit}) : super(key: key);

  @override
  State<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCategory;
  String _selectedFrequency = 'Hàng tháng';
  late DateTime _reminderDate;
  late DateTime _dueDate;
  ReminderStatus _currentStatus = ReminderStatus.pending;

  final List<String> _categories = [
    'Thanh toán hóa đơn',
    'Trả góp xe',
    'Tiền điện',
    'Tiền nước',
    'Internet',
    'Bảo hiểm',
    'Học phí',
  ];

  final List<String> _frequencies = [
    'Hàng ngày',
    'Hàng tuần',
    'Hàng tháng',
    'Hàng năm',
    'Một lần',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.reminderToEdit != null) {
      final r = widget.reminderToEdit!;
      _selectedCategory = r.title;
      _amountController.text = r.amount.toStringAsFixed(0);
      _selectedFrequency = r.frequency;
      _reminderDate = r.reminderDate;
      _dueDate = r.dueDate;
      _noteController.text = r.note ?? '';
      _currentStatus = r.status;
    } else {
      _reminderDate = DateTime.now();
      _dueDate = DateTime.now();
    }
  }

  Future<void> _pickDate(bool isReminderDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isReminderDate ? _reminderDate : _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isReminderDate) {
          _reminderDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.reminderToEdit != null;
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final amountPreview = double.tryParse(_amountController.text) ?? 0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Sửa nhắc nhở' : 'Đặt lịch nhắc',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'Loại hóa đơn',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text('Chọn loại hóa đơn'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),
              const SizedBox(height: 16),

              const Text(
                'Số tiền (VND)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              if (amountPreview > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(
                    formatCurrency.format(amountPreview),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              const Text(
                'Tần suất lặp lại',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items: _frequencies
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedFrequency = val!),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ngày nhắc',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _pickDate(true),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: TextEditingController(
                                text: DateFormat('dd/MM/yyyy')
                                    .format(_reminderDate),
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ngày đến hạn',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _pickDate(false),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: TextEditingController(
                                text: DateFormat('dd/MM/yyyy').format(_dueDate),
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (isEditing) ...[
                const SizedBox(height: 16),
                const Text(
                  'Trạng thái',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ReminderStatus>(
                  value: _currentStatus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: ReminderStatus.pending,
                      child: Text('Chờ tới hạn'),
                    ),
                    DropdownMenuItem(
                      value: ReminderStatus.paid,
                      child: Text('Đã thanh toán'),
                    ),
                    DropdownMenuItem(
                      value: ReminderStatus.overdue,
                      child: Text('Quá hạn'),
                    ),
                  ],
                  onChanged: (val) => setState(() => _currentStatus = val!),
                ),
              ],

              const SizedBox(height: 16),
              const Text(
                'Ghi chú',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Không bắt buộc',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () {
                      if (_selectedCategory == null) return;
                      final amount =
                          double.tryParse(_amountController.text) ?? 0;

                      final newReminder = ReminderModel(
                        id: isEditing
                            ? widget.reminderToEdit!.id
                            : DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _selectedCategory!,
                        amount: amount,
                        frequency: _selectedFrequency,
                        reminderDate: _reminderDate,
                        dueDate: _dueDate,
                        note: _noteController.text,
                        status: _currentStatus,
                      );
                      newReminder.updateStatusBasedOnDate();
                      Navigator.pop(context, newReminder);
                    },
                    child: Text(
                      isEditing ? 'LƯU THAY ĐỔI' : 'LƯU NHẮC NHỞ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
