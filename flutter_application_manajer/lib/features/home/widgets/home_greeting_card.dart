import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';

class HomeGreetingCard extends StatelessWidget {
  final String username;

  const HomeGreetingCard({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF7BC148), Color(0xFF5FA133)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Halo, $username!", style: AppTextStyles.homeGreeting),
          const SizedBox(height: 8),
          const Text(
            "Apa yang ingin Anda pesan hari ini?",
            style: AppTextStyles.homeSubtitle,
          ),
        ],
      ),
    );
  }
}
