import 'package:doan_appqlthuchi/features/dashboard/presentation/pages/main_layout.dart';
import 'package:flutter/material.dart';

import 'features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Chi Tiêu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter', primarySwatch: Colors.blue),
      home: const MainLayout(),
    );
  }
}
