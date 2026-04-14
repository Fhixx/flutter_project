import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';

class HomeGreetingCard extends StatelessWidget {
  final String nama;

  const HomeGreetingCard({
    super.key,
    required this.nama,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // biar nggak mepet
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // lebih kotak
          gradient: const LinearGradient(
            colors: [Color(0xFF7BC148), Color(0xFF5FA133)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text("Halo, $nama!", style: AppTextStyles.homeGreeting),
            const SizedBox(height: 8),
            const Text(
              "Semangat Bekerja Hari ini",
              style: AppTextStyles.homeSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}