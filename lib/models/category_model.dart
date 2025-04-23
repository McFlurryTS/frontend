import 'package:flutter/material.dart';

class MenuCategory {
  final String id;
  final String name;
  final String imageUrl;

  MenuCategory({required this.id, required this.name, required this.imageUrl});

  Color get color {
    final Map<String, Color> categoryColors = {
      'DESAYUNOS': const Color(0xFFFFF3E0), // Naranja desayuno suave
      'A_LA_CARTA_PAPAS': const Color(0xFFFFF8E1), // Amarillo dorado suave
      'A_LA_CARTA_HAMBURGUESAS': const Color(0xFFFFEBEE), // Rojo marca suave
      'A_LA_CARTA_NUGGETS': const Color(0xFFF3E5F5), // Morado suave
      'PROMOCIONES': const Color(0xFFFCE4EC), // Rosa promocional
      'BEBIDAS': const Color(0xFFE3F2FD), // Azul refrescante
      'TU_FAV_99': const Color(0xFFE8F5E9), // Verde suave
      'FAMILY_BOX': const Color(0xFFFFF3E0), // Naranja familiar
      'POSTRES_Y_MALTEADAS': const Color(0xFFF9FBE7), // Lima helado
      'CAJITA_FELIZ': const Color(0xFFFFECB3), // Amarillo feliz
      'EXCLUSIVO_PICKUP': const Color(0xFFE0F7FA), // Cyan exclusivo
      'MCTRIOS_MEDIANOS': const Color(0xFFF1F8E9), // Verde trio
      'MCTRIOS_GRANDES': const Color(0xFFE8EAF6), // Indigo suave
      'MCTRIO_3X3': const Color(0xFFFCE4EC), // Rosa especial
      'A_LA_CARTA_COMIDA': const Color(0xFFEDE7F6), // Púrpura suave
    };

    if (categoryColors.containsKey(id)) {
      return categoryColors[id]!;
    }

    final defaultColors = [
      const Color(0xFFFFEBEE), // Rojo McD suave
      const Color(0xFFFFF3E0), // Naranja McD suave
      const Color(0xFFFFF8E1), // Amarillo McD suave
      const Color(0xFFF3E5F5), // Morado complementario
      const Color(0xFFE3F2FD), // Azul complementario
      const Color(0xFFE8F5E9), // Verde complementario
      const Color(0xFFEDE7F6), // Violeta complementario
      const Color(0xFFFCE4EC), // Rosa complementario
    ];

    return defaultColors[id.hashCode % defaultColors.length];
  }

  Color get darkerColor => Color.fromARGB(
    color.alpha,
    (color.red * 0.8).round(),
    (color.green * 0.8).round(),
    (color.blue * 0.8).round(),
  );
}
