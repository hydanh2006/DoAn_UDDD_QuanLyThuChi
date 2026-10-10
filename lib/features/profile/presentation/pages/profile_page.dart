import 'package:flutter/material.dart';
import 'package:doan_appqlthuchi/features/auth/presentation/pages/login_page.dart';

class CategoryItem {
  String name;
  String type; // 'Thu nhập' hoặc 'Chi phí'
  IconData icon;

  CategoryItem({required this.name, required this.type, required this.icon});
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CategoryItem> categories = [
    CategoryItem(name: 'Ăn uống', type: 'Thu nhập', icon: Icons.restaurant),
    CategoryItem(name: 'Ăn vặt', type: 'Chi phí', icon: Icons.fastfood),
    CategoryItem(
      name: 'Lương',
      type: 'Thu nhập',
      icon: Icons.account_balance_wallet,
    ),
    CategoryItem(name: 'Tiền nhà', type: 'Chi phí', icon: Icons.home),
  ];

  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Xóa danh mục',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa danh mục "${categories[index].name}" không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy', style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => categories.removeAt(index));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Đã xóa danh mục')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog({int? indexToEdit}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddCategoryDialog(
        categoryToEdit: indexToEdit != null ? categories[indexToEdit] : null,
      ),
    ).then((result) {
      if (result != null && result is CategoryItem) {
        setState(() {
          if (indexToEdit != null) {
            categories[indexToEdit] = result;
          } else {
            categories.add(result);
          }
        });
      }
    });
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Xác nhận đăng xuất',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy', style: TextStyle(color: Colors.grey.shade700)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: isMobile
              ? const Drawer(child: Center(child: Text("Menu Điều Hướng")))
              : null,
          floatingActionButton: isMobile
              ? FloatingActionButton(
                  backgroundColor: Colors.white,
                  elevation: 4,
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  child: const Icon(Icons.menu, color: Colors.black87),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hồ sơ & Cài đặt",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Cập nhật thông tin cá nhân và quản lý danh mục chi tiêu của bạn.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),

                if (isMobile)
                  Column(
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: 16),
                      _buildInfoForm(),
                      const SizedBox(height: 16),
                      _buildCategoryCard(isMobile: true),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildProfileCard(),
                            const SizedBox(height: 24),
                            _buildInfoForm(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 6,
                        child: _buildCategoryCard(isMobile: false),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue.shade50,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Minh Tân",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "tankg509@gmail.com",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_outlined, size: 18),
              label: const Text("Đổi ảnh đại diện"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField("Họ tên hiển thị", "Minh Tân"),
          const SizedBox(height: 16),
          _buildTextField("Email", "tankg509@gmail.com"),
          const SizedBox(height: 16),
          _buildTextField("Số điện thoại", "Ví dụ: 0912345678"),
          const SizedBox(height: 16),
          _buildTextField("Đơn vị tiền tệ", "VND"),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "LƯU THAY ĐỔI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      const ChangePasswordDialog(),
                );
              },
              child: Text(
                "Đổi mật khẩu",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Danh mục của tôi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCategoryDialog(),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: isMobile
                    ? const Text("Thêm", style: TextStyle(color: Colors.white))
                    : const Text(
                        "Thêm danh mục",
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(cat.icon, color: Colors.blue.shade800),
                ),
                title: Text(
                  cat.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          cat.type,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () =>
                            _showCategoryDialog(indexToEdit: index),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.red.shade400,
                        ),
                        onPressed: () => _deleteCategory(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: isMobile ? double.infinity : null,
            child: OutlinedButton.icon(
              onPressed: _showLogoutConfirmDialog,
              icon: const Icon(Icons.logout, size: 18),
              label: const Text("ĐĂNG XUẤT"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade800,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddCategoryDialog extends StatefulWidget {
  final CategoryItem? categoryToEdit;
  const AddCategoryDialog({Key? key, this.categoryToEdit}) : super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late TextEditingController _nameController;
  late String _selectedType;
  late IconData _selectedIcon;

  final List<IconData> _availableIcons = [
    Icons.restaurant,
    Icons.home,
    Icons.shopping_bag,
    Icons.directions_car,
    Icons.account_balance_wallet,
    Icons.favorite,
    Icons.school,
    Icons.receipt,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.categoryToEdit?.name ?? '',
    );
    _selectedType = widget.categoryToEdit?.type ?? 'Chi phí';
    _selectedIcon = widget.categoryToEdit?.icon ?? Icons.restaurant;
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.categoryToEdit != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? "Sửa danh mục" : "Thêm danh mục",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Tên danh mục",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTypeChip('Thu nhập'),
                  const SizedBox(width: 8),
                  _buildTypeChip('Chi phí'),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _availableIcons.map((icon) {
                  final isSelected = _selectedIcon == icon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue.shade600
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Colors.blue.shade800
                            : Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Hủy",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        Navigator.pop(
                          context,
                          CategoryItem(
                            name: _nameController.text,
                            type: _selectedType,
                            icon: _selectedIcon,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                    ),
                    child: const Text(
                      "LƯU",
                      style: TextStyle(color: Colors.white),
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

  Widget _buildTypeChip(String type) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue.shade100 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade800 : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Đổi mật khẩu",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildPasswordField(
                label: "Mật khẩu hiện tại",
                controller: _currentPasswordController,
                isObscure: _obscureCurrent,
                onToggleVisibility: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: "Mật khẩu mới",
                controller: _newPasswordController,
                isObscure: _obscureNew,
                onToggleVisibility: () =>
                    setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: "Xác nhận mật khẩu mới",
                controller: _confirmPasswordController,
                isObscure: _obscureConfirm,
                onToggleVisibility: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đổi mật khẩu thành công!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "LƯU THAY ĐỔI",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            hintText: "Nhập $label...",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.shade600,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
