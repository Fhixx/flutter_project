import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon; 
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white), 
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: AppTextStyles.menuText),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}