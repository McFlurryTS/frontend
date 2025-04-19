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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  NotificationService.getFavoriteProducts().map((product) {
                    final isSelected = provider.isOptionSelected(0, product);
                    if (isSelected) {
                      NotificationService.subscribeToTopic(product);
                    } else {
                      NotificationService.unsubscribeFromTopic(product);
                    }
                    return _buildOptionCard(
                      text: product,
                      isSelected: isSelected,
                      onTap: () => provider.toggleOption(0, product),
                    );
                  }).toList(),
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
              color: isSelected ? Colors.black : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
