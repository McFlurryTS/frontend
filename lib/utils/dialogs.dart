import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rocket_theme.dart';

Future<bool> showContinueDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '¿Desea continuar?',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: RocketColors.text,
              ),
            ),
            content: Text(
              '¿Está seguro que desea continuar con la iteración?',
              style: GoogleFonts.poppins(color: RocketColors.text),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RocketColors.primary,
                ),
                child: Text(
                  'Continuar',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}
