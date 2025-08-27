import 'package:flutter/material.dart';


class AppColors {
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color textBlue = Color(0xFF0D47A1);
  static const Color backgroundColor = Colors.white;
  static const Color mutedColor = Colors.grey;
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF388E3C);
  static const Color offWhite = Color(0xFFF8F8F8);
  static const Color warningYellow = Color(0xFFFFC107);
}

final ThemeData taskistTheme = ThemeData(

  brightness: Brightness.light,
  primaryColor: AppColors.primaryBlue,
  scaffoldBackgroundColor: AppColors.backgroundColor,

  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: AppColors.textBlue,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: AppColors.textBlue,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: AppColors.textBlue,
      fontSize: 14,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textBlue,
      fontSize: 12,
    ),
  ).apply(
    fontFamily: 'Roboto', 
  ),

  
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.backgroundColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: AppColors.textBlue,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: AppColors.primaryBlue),
  ),

  
  inputDecorationTheme: InputDecorationTheme(
    filled: false,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primaryBlue),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primaryBlue),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
    ),
    labelStyle: TextStyle(color: AppColors.primaryBlue),
    hintStyle: TextStyle(color: AppColors.primaryBlue.withValues(alpha: 0.5)),
  ),

  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),

  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: AppColors.primaryBlue,
      side: BorderSide(color: AppColors.primaryBlue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  ),

  iconTheme: IconThemeData(color: AppColors.primaryBlue),
);