import 'package:flutter/material.dart';
import 'package:McDonalds/utils/rocket_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RocketColors.background,
      appBar: AppBar(
        title: const Text('Centro de Ayuda'),
        backgroundColor: const Color(0xFFDA291C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHelpHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildHelpSection('Preguntas Frecuentes', [
                    {
                      'question': '¿Cómo funciona McDelivery?',
                      'answer':
                          'McDelivery te permite pedir tus productos favoritos de McDonald\'s directamente a tu puerta. Solo selecciona tus productos, confirma tu dirección y realiza el pago.',
                    },
                    {
                      'question': '¿Cómo gano puntos MyMcDonald\'s Rewards?',
                      'answer':
                          'Gana 100 puntos por cada \$1 gastado. Escanea el código QR en el restaurante o realiza pedidos a través de la app.',
                    },
                    {
                      'question': '¿Dónde encuentro el menú completo?',
                      'answer':
                          'Puedes encontrar nuestro menú completo en la sección "Menú" de la app o visitando cualquier restaurante McDonald\'s.',
                    },
                  ]),
                  const SizedBox(height: 24),
                  _buildContactSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDA291C), Color(0xFFFF1C1C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const Text(
            '¿Cómo podemos ayudarte?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Encuentra respuestas rápidas a tus preguntas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar ayuda...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, List<Map<String, String>> items) {
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
        const SizedBox(height: 16),
        ...items.map(
          (item) =>
              _buildExpandableQuestion(item['question']!, item['answer']!),
        ),
      ],
    );
  }

  Widget _buildExpandableQuestion(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contacto Directo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          icon: Icons.phone,
          title: 'Llámanos',
          subtitle: 'Disponible 24/7',
          action: '01-800-MEX-MCDN',
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          icon: Icons.mail,
          title: 'Envíanos un correo',
          subtitle: 'Te responderemos en 24 horas',
          action: 'ayuda@mcdonalds.com.mx',
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String action,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: RocketColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: RocketColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            action,
            style: TextStyle(
              fontSize: 14,
              color: RocketColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
