import 'package:flutter/material.dart';
import 'package:doan_appqlthuchi/core/theme/app_colors.dart';
import 'package:doan_appqlthuchi/features/dashboard/presentation/pages/main_layout.dart';

import 'register_page.dart';
import 'forgot_password_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _hasError = false; // Biến kiểm soát việc hiện lỗi

  // Bộ điều khiển để lấy dữ liệu người dùng nhập
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Lấy tài khoản đã lưu từ bộ nhớ máy
    final prefs = await SharedPreferences.getInstance();
    // Nếu chưa có ai đăng ký, mặc định cho phép dùng admin/123456
    final savedUsername = prefs.getString('saved_username') ?? 'admin';
    final savedPassword = prefs.getString('saved_password') ?? '123456';

    // So sánh dữ liệu nhập vào với dữ liệu trong bộ nhớ
    if (username == savedUsername && password == savedPassword) {
      setState(() {
        _hasError = false;
      });
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );
      }
    } else {
      setState(() {
        _hasError = true;
      });
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
              // Logo & Title
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
                'Moni',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Quản lý tài chính cá nhân của bạn',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // Form Container
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
                      'Tên đăng nhập hoặc Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline),
                        hintText: 'Nhập tên đăng nhập hoặc email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      // Tắt lỗi khi người dùng bắt đầu nhập lại
                      onChanged: (value) {
                        if (_hasError) setState(() => _hasError = false);
                      },
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
                        hintText: 'Nhập mật khẩu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      // Tắt lỗi khi người dùng bắt đầu nhập lại
                      onChanged: (value) {
                        if (_hasError) setState(() => _hasError = false);
                      },
                    ),
                    const SizedBox(height: 24),

                    // KHỐI HIỂN THỊ LỖI ĐỎ
                    if (_hasError) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: const Text(
                          'Tên đăng nhập hoặc mật khẩu không đúng. Vui lòng thử lại.',
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _handleLogin,
                        child: const Text(
                          'ĐĂNG NHẬP',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'QUÊN MẬT KHẨU',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
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
                    'Chưa có tài khoản? ',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Đợi kết quả trả về từ trang RegisterPage
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                      // Nếu có kết quả trả về, tự động điền vào các ô TextField
                      if (result != null && result is Map<String, String>) {
                        setState(() {
                          _usernameController.text = result['username'] ?? '';
                          _passwordController.text = result['password'] ?? '';
                          // Có thể gán _hasError = false ở đây để xóa cảnh báo đỏ cũ nếu có
                          _hasError = false;
                        });
                      }
                    },
                    child: const Text(
                      'Đăng ký tại đây',
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
}
