import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const saffron = Color(0xFFFF6F00);
  static const saffronLight = Color(0xFFFF8F00);
  static const gold = Color(0xFFFFCA28);
  static const goldDark = Color(0xFFFFB300);
  static const vermillion = Color(0xFFD32F2F);
  static const turmeric = Color(0xFFFFF8E1);
  static const sandalwood = Color(0xFFFAF3E0);
  static const templeBlack = Color(0xFF1A0A00);
  static const templeBrown = Color(0xFF2A1500);
  static const diyaGlow = Color(0xFFFFE082);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.saffron,
        primary: AppColors.saffron,
        secondary: AppColors.gold,
        surface: Colors.white,
        background: AppColors.sandalwood,
      ),
      scaffoldBackgroundColor: AppColors.sandalwood,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.saffron,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.saffron,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 11),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: AppColors.saffron,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.saffron,
        brightness: Brightness.dark,
        primary: AppColors.saffronLight,
        secondary: AppColors.gold,
        surface: AppColors.templeBrown,
        background: AppColors.templeBlack,
      ),
      scaffoldBackgroundColor: AppColors.templeBlack,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.templeBrown,
        foregroundColor: AppColors.gold,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.gold,
          letterSpacing: 0.3,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.templeBrown,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedLabelStyle: TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 11),
      ),
      cardTheme: CardThemeData(
        color: AppColors.templeBrown,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black54,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffronLight,
          foregroundColor: AppColors.templeBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
