import 'package:flutter/material.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Trạng thái các điều kiện
  bool _hasMinLength = false;
  bool _hasSymbolOrNumber = false;
  bool _notMatchUsername = false;

  String? _errorText;
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // Hàm kiểm tra logic theo thời gian thực
  void _validateForm() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    setState(() {
      // 1. Kiểm tra 3 điều kiện mật khẩu
      _hasMinLength = password.length >= 8;
      _hasSymbolOrNumber = RegExp(r'[0-9\W_]')
          .hasMatch(password); // Có số hoặc ký tự đặc biệt
      _notMatchUsername = password.isNotEmpty && password != username;

      bool allConditionsMet =
          _hasMinLength && _hasSymbolOrNumber && _notMatchUsername;
      bool passwordsMatch = password == confirm;

      // 2. Hiển thị thông báo lỗi
      if (password.isNotEmpty && !allConditionsMet) {
        _errorText = 'Mật khẩu chưa đủ điều kiện';
      } else if (confirm.isNotEmpty && !passwordsMatch) {
        _errorText = 'Hai mật khẩu không khớp';
      } else {
        _errorText = null;
      }

      // 3. Kích hoạt nút đăng ký
      _isButtonEnabled =
          username.isNotEmpty && allConditionsMet && passwordsMatch;
    });
  }

  void _handleRegister() async {
    if (_isButtonEnabled) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      // Lưu tài khoản vào bộ nhớ máy
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_username', username);
      await prefs.setString('saved_password', password);

      if (mounted) {
        // Trả dữ liệu về trang Đăng nhập để tự động điền
        Navigator.pop(context, {'username': username, 'password': password});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'M',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tạo tài khoản Moni',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tên đăng nhập',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      onChanged: (_) => _validateForm(),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline),
                        hintText: 'Chọn tên đăng nhập',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Mật khẩu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (_) => _validateForm(),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Nhập lại mật khẩu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      onChanged: (_) => _validateForm(),
                      decoration: InputDecoration(
                        hintText: 'Nhập lại mật khẩu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Danh sách điều kiện checkmark
                    _buildCondition('Ít nhất 8 ký tự', _hasMinLength),
                    _buildCondition(
                      'Có ký hiệu hoặc chữ số',
                      _hasSymbolOrNumber,
                    ),
                    _buildCondition(
                      'Không trùng tên đăng nhập',
                      _notMatchUsername,
                    ),
                    const SizedBox(height: 12),

                    // Thông báo lỗi đỏ
                    if (_errorText != null)
                      Text(
                        _errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Nút Đăng Ký
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonEnabled
                              ? AppColors.primary
                              : Colors.blueAccent.withOpacity(0.6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isButtonEnabled ? _handleRegister : null,
                        child: const Text(
                          'ĐĂNG KÝ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Đã có tài khoản? ',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
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

  // Widget hiển thị từng dòng điều kiện
  Widget _buildCondition(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(
            Icons.check,
            size: 18,
            color: isMet ? Colors.green : Colors.grey.shade400,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.green : Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
