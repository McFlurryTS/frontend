import 'package:flutter/material.dart';
import 'package:McDonalds/utils/rocket_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RocketColors.background,
      appBar: AppBar(
        title: const Text('Acerca de McDonald\'s'),
        backgroundColor: const Color(0xFFDA291C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    'Nuestra Historia',
                    'McDonald\'s inició su viaje en 1940 como un pequeño restaurante en San Bernardino, California. Hoy, somos una de las cadenas de restaurantes más grandes del mundo, sirviendo a millones de clientes cada día en más de 100 países.',
                  ),
                  const SizedBox(height: 24),
                  _buildStatistics(),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    'Nuestro Compromiso',
                    'En McDonald\'s nos comprometemos a utilizar ingredientes de la más alta calidad y a mantener los más altos estándares de seguridad alimentaria. Trabajamos con proveedores locales y mantenemos rigurosos controles de calidad.',
                  ),
                  const SizedBox(height: 24),
                  _buildValuesList(),
                  const SizedBox(height: 24),
                  _buildAppInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDA291C), Color(0xFFFF1C1C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Image.asset('assets/icons/logo/72_logo.png', height: 80),
          const SizedBox(height: 16),
          const Text(
            'i\'m lovin\' it',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
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
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('40,000+', 'Restaurantes'),
        _buildStatItem('100+', 'Países'),
        _buildStatItem('69M+', 'Clientes Diarios'),
      ],
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: RocketColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildValuesList() {
    final List<Map<String, dynamic>> values = [
      {'icon': Icons.check_circle, 'text': 'Calidad'},
      {'icon': Icons.people, 'text': 'Servicio'},
      {'icon': Icons.clean_hands, 'text': 'Limpieza'},
      {'icon': Icons.monetization_on, 'text': 'Valor'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nuestros Valores',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        ...values.map(
          (value) => _buildValueItem(
            value['icon'] as IconData,
            value['text'] as String,
          ),
        ),
      ],
    );
  }

  Widget _buildValueItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: RocketColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: RocketColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de la App',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildAppInfoRow('Versión', '1.0'),
          _buildAppInfoRow('Última actualización', '19 de abril, 2025'),
          _buildAppInfoRow('Desarrollado por el equipo:', 'McFlurry.ts'),
        ],
      ),
    );
  }

  Widget _buildAppInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }
}
