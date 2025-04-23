import 'package:flutter/material.dart';
import 'package:McDonalds/utils/rocket_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RocketColors.background,
      appBar: AppBar(
        title: const Text('Privacidad'),
        backgroundColor: const Color(0xFFDA291C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Datos Personales',
              'McDonald\'s se compromete a proteger tu privacidad y tus datos personales. Utilizamos tecnología de encriptación de última generación para mantener tus datos seguros.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Programa MyMcDonald\'s Rewards',
              'Como miembro del programa de recompensas, recopilamos datos sobre tus pedidos para personalizar tu experiencia y ofrecerte recompensas relevantes.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Localización',
              'Utilizamos tu ubicación solo cuando la app está en uso para mostrarte los restaurantes más cercanos y mejorar tu experiencia de entrega.',
            ),
            const SizedBox(height: 24),
            _buildPermissionTile(
              'Localización',
              'Permite encontrar restaurantes cercanos',
              true,
            ),
            _buildPermissionTile(
              'Cámara',
              'Para escanear códigos QR de recompensas',
              false,
            ),
            _buildPermissionTile(
              'Notificaciones',
              'Recibe ofertas especiales y actualizaciones',
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildPermissionTile(String title, String subtitle, bool isEnabled) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      value: isEnabled,
      onChanged: (value) {
        // Aquí implementarías la lógica real para cambiar permisos
      },
      activeColor: RocketColors.primary,
    );
  }
}
