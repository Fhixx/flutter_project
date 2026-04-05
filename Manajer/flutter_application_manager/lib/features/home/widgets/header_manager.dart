import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';

class HeaderManager extends StatelessWidget {
  const HeaderManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.fromLTRB(50, 25, 50, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7BC148), Color(0xFF5FA133)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
          top: Radius.circular(20)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Dashboard Manager", style: AppTextStyles.header),
          SizedBox(height: 8),
          Text("Selamat Datang, Manager", style: AppTextStyles.header),
          SizedBox(height: 4),
          Text(
            "Monitor dan kelola sistem dengan mudah",
            style: AppTextStyles.subHeader,
          ),
        ],
      ),
    );
  }
}