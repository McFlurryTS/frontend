import 'package:flutter/material.dart';

class RocketColors {
  static const Color primary = Color(0xFFFFC72C); // Amarillo McDonald's
  static const Color secondary = Color(0xFFD00000); // Rojo McDonald's
  static const Color background = Color(0xFFF5F5F5); // Fondo claro
  static const Color backgroundBar = Color(0xFFF4F4F4); // Fondo claro
  static const Color text = Color(0xFF1A1A1A); // Texto oscuro
  static const Color accent = Color(0xFF006BA6); // Azul de apoyo
  static const Color offIcons = Color(0x4027251F); // Borde gris claro
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
}

class RocketTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: RocketColors.text,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: RocketColors.text,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: RocketColors.text,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle button2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: RocketColors.text,
  );
}

class RocketButtonStyles {
  static final ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: RocketColors.primary,
    textStyle: RocketTextStyles.button,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static final ButtonStyle secondary = ElevatedButton.styleFrom(
    backgroundColor: RocketColors.secondary,
    textStyle: RocketTextStyles.button,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
