import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const label = TextStyle(
    fontSize: 14,
    color: AppColors.textLabel,
  );

  static const hint = TextStyle(
    fontSize: 14,
    color: Color(0x7F0A0A0A),
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );



  static const homeTitle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.w400,
  );

  static const homeGreeting = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static const homeSubtitle = TextStyle(
    color: Color(0xE5FFFEFE),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const homeMenu = TextStyle(
    color: Color(0xFF1D2838),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );



static const sectionTitle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Color(0xFF222222),
);

static const formLabel = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: Color(0xFF444444),
);

}

