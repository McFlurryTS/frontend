import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/providers/onboarding_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:McDonalds/services/notification_service.dart';

class StepOne extends StatelessWidget {
  const StepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Cuál es tu combo o producto estrella en McDonald\'s?',
              style: RocketTextStyles.headline2.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<String>>(
              future: NotificationService.getFavoriteProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay productos disponibles'),
                  );
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      snapshot.data!.map((product) {
                        final isSelected = provider.isOptionSelected(
                          0,
                          product,
                        );

                        return _buildOptionCard(
                          text: product,
                          isSelected: isSelected,
                          onTap: () async {
                            provider.toggleOption(0, product);
                            try {
                              if (isSelected) {
                                await NotificationService.unsubscribeFromTopic(
                                  product,
                                );
                              } else {
                                await NotificationService.subscribeToTopic(
                                  product,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error al actualizar las notificaciones: $e',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        );
                      }).toList(),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionCard({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? RocketColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? RocketColors.primary : Colors.grey[300]!,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
