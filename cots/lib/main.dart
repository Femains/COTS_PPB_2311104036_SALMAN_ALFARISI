import 'package:flutter/material.dart';
import 'design_system/colors.dart';
import 'presentation/dashboard/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COTS Task App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
      ),
      home: const DashboardPage(),
    );
  }
}
