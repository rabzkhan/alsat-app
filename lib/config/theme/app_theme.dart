import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

ThemeData appTheme() => ThemeData(
      useMaterial3: false,
      fontFamily: GoogleFonts.inter().fontFamily,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.white,
        labelStyle: bold,
        unselectedLabelStyle: medium,
        indicator: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // Change the color here
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
    );
