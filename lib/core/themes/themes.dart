import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: false,
  primaryColor: Color(0xFF69BE28), // Green accent used for buttons and highlights
  scaffoldBackgroundColor: Color(0xFFF7FFE9), // Pale green background
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF69BE28),      // Button and highlight green
    secondary: Color(0xFF2E2E2E),    // Bottom nav background
    surface: Color(0xFFF7FFE9),      // Card and scaffold surface
    error: Colors.red,
    onPrimary: Colors.white,         // Text on green buttons
    onSecondary: Colors.white,       // Text on dark nav
    onSurface: Colors.black87,       // General text
    onError: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFF7FFE9),
    foregroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  cardColor: Color(0xFFEFFFE0),
  iconTheme: IconThemeData(
    color: Color(0xFF69BE28),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF2E2E2E),
    selectedItemColor: Color(0xFF69BE28),
    unselectedItemColor: Colors.white,
    showSelectedLabels: true,
    showUnselectedLabels: false,
  ),



  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF69BE28), // ✅ Figma green
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins', // ✅ Use declared font family
      ),
      elevation: 0,
    ),
  ),


  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFEFFFE0),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: Colors.black87,
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'assets/fonts/Poppins-Regular.ttf',
    ),
    headlineSmall: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'assets/fonts/Poppins-Medium.ttf',
    ),
    headlineMedium: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'assets/fonts/Poppins-SemiBold.ttf',
    ),
    labelMedium: TextStyle(
      fontFamily: 'assets/fonts/Poppins-Medium.ttf',
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
    ),
  ),
);
