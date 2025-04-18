import 'package:flutter/material.dart';
import '../utils/rocket_theme.dart';
import '../widgets/rocket_button.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RocketColors.background,
      appBar: AppBar(
        title: const Text("Pantalla de Demostración"),
        backgroundColor: RocketColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RocketButton(
              label: "Botón Primario",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Botón presionado")),
                );
              },
            ),
            const SizedBox(height: 20),
            RocketButton(
              label: "Botón Secundario",
              isPrimary: false,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
