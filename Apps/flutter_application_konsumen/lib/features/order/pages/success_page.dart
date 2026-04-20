import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/pages/home_page.dart';
import '../../../core/session/user_session.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {

  @override
  void initState() {
    super.initState();

    /// Delay 3 detik lalu pindah
    Future.delayed(const Duration(seconds: 3), () {
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomePage(
        username: UserSession.username!,
        userId: UserSession.id!,
      )),
      (route) => false,
    );
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      body: Stack(
        children: [
          /// HEADER
          Container(
            height: 90,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pembayaran",
                    style: AppTextStyles.homeTitle,
                  ),
                ),
              ),
            ),
          ),

          /// CONTENT
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.check_circle,
                  size: 80,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16),
                Text(
                  "Pembayaran Berhasil!",
                  style: AppTextStyles.sectionTitle,
                ),
                SizedBox(height: 8),
                Text(
                  "Pesanan Anda sedang diproses",
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}