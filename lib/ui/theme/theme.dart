import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor= Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color black = Color(0xFF212121);    
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightbluewhite = Color(0xFFF0F4FF);
  static const Color brown = Color(0xFF9E5C00);
}

class AppTextStyles {
  static TextStyle heading = TextStyle (fontSize: 28, fontWeight: FontWeight.w500, color: AppColors.darkGreen);

  static TextStyle body = TextStyle (fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.black);

  static TextStyle label = TextStyle (fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.lightGrey);

  static TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}

ThemeData appTheme = ThemeData(
  fontFamily: 'Inter',
  scaffoldBackgroundColor: AppColors.white,
);
