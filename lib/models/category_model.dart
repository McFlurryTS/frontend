import 'package:flutter/material.dart'; // Importación necesaria para usar Color

class MenuCategory {
  final String id;
  final String name;
  final String imageUrl;
  final String endpoint;

  MenuCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.endpoint,
  });

  // Generar colores dinámicamente basados en el ID
  Color get color {
    final colors = [
      const Color(0xFFd7e7fe), // Naranja
      const Color(0xFFe9ffdb), // Rojo
      const Color(0xFFffe1d7), // Azul
      const Color(0xFFe7d9fd), // Verde
      const Color(0xFFfff6d9), // Morado
    ];
    return colors[id.hashCode % colors.length];
  }

  // Versión más oscura del color
  Color get darkerColor => Color.fromARGB(
    color.alpha,
    (color.red * 0.8).round(),
    (color.green * 0.8).round(),
    (color.blue * 0.8).round(),
  );
}
