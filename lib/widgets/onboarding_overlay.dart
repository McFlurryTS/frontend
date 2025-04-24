import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:McDonalds/providers/onboarding_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:lottie/lottie.dart';

class OnboardingOverlay extends StatelessWidget {
  const OnboardingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, provider, _) {
        return Material(
          color: RocketColors.background,
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(provider.currentStep),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        provider.showThankYou
                            ? _buildThankYouSection(context, provider)
                            : _buildFormSection(context, provider),
                  ),
                ),
                if (!provider.showThankYou)
                  _buildNavigationButtons(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(int currentStep) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/mcdonals_promo.jpg',
            height: 48,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween<double>(
              begin: (currentStep) / 8,
              end: (currentStep + 1) / 8,
            ),
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  RocketColors.primary,
                ),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Paso ${currentStep + 1} de 8',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: RocketColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context, OnboardingProvider provider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (provider.currentStep == 0) ...[
              _buildWelcomeMessage(),
              const SizedBox(height: 32),
            ],
            Text(
              _getStepTitle(provider.currentStep),
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: RocketColors.text,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _getStepOptions(provider.currentStep).length,
              itemBuilder: (context, index) {
                final option = _getStepOptions(provider.currentStep)[index];
                final isSelected = provider.isOptionSelected(
                  provider.currentStep,
                  option,
                );
                return _buildOptionCard(
                  context,
                  option,
                  isSelected,
                  () => provider.toggleOption(provider.currentStep, option),
                  provider.currentStep,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        'Queremos conocerte un poquito mejor para darte justo lo que te encanta',
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: RocketColors.text,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    String option,
    bool isSelected,
    VoidCallback onTap,
    int currentStep,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? RocketColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(child: _getOptionImage(currentStep, option)),
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: RocketColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: Center(
                  child: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.2,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: RocketColors.text,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getOptionImage(int step, String option) {
    // Definimos la imagen por defecto según el paso basado en la primera opción de cada conjunto
    String defaultImageForStep(int step) {
      switch (step) {
        case 0: // Primer paso: productos principales - burger.png
          return 'assets/images/burger.png';
        case 1: // Segundo paso: postres - mcflurry.png
          return 'assets/images/mcflurry.png';
        case 2: // Tercer paso: regalos - todas las imágenes disponibles
          if (option.toLowerCase().contains('hamburguesa')) {
            return 'assets/images/burger.png';
          } else if (option.toLowerCase().contains('papas')) {
            return 'assets/images/fries.png';
          } else if (option.toLowerCase().contains('soda') ||
              option.toLowerCase().contains('refresco')) {
            return 'assets/images/soda.png';
          } else if (option.toLowerCase().contains('helado') ||
              option.toLowerCase().contains('postre')) {
            return 'assets/images/mcflurry.png';
          }
          return 'assets/images/burger.png';
        case 3: // Cuarto paso: para quién compras - burger.png
          return 'assets/images/burger.png';
        case 4: // Quinto paso: sabores - fries.png
          return 'assets/images/fries.png';
        case 5: // Sexto paso: por qué no vienes - burger.png
          return 'assets/images/burger.png';
        case 6: // Séptimo paso: sorpresas - mcflurry.png
          return 'assets/images/mcflurry.png';
        case 7: // Octavo paso: acompañamiento
          if (option.toLowerCase().contains('papas')) {
            return 'assets/images/fries.png';
          } else if (option.toLowerCase().contains('refresco')) {
            return 'assets/images/soda.png';
          } else if (option.toLowerCase().contains('postre')) {
            return 'assets/images/mcflurry.png';
          }
          return 'assets/images/burger.png';
        default:
          return 'assets/images/burger.png';
      }
    }

    return Image.asset(
      defaultImageForStep(step),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.fastfood, size: 40, color: Colors.grey[400]);
      },
    );
  }

  Widget _buildThankYouSection(
    BuildContext context,
    OnboardingProvider provider,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThankYouAnimation(),
            const SizedBox(height: 32),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '¡Gracias por hacernos parte de tus antojos!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: RocketColors.text,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Muy pronto verás algo delicioso solo para ti',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: RocketColors.text,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed:
                  !provider.isLoading
                      ? () => provider.completeOnboarding(context)
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: RocketColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child:
                  !provider.isLoading
                      ? Text(
                        '¡Iniciar mi experiencia McDonald\'s!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                      : const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYouAnimation() {
    return Builder(
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              height: 250,
              repeat: false,
              errorBuilder: (context, error, stackTrace) {
                return _buildFallbackAnimation();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFallbackAnimation() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RocketColors.primary.withOpacity(0.1),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 120,
                  color: RocketColors.primary.withOpacity(value),
                ),
                Transform.rotate(
                  angle: value * 6.28319,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: RocketColors.primary.withOpacity(value * 0.5),
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    OnboardingProvider provider,
  ) {
    final bool canContinue = provider.canContinue();

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (provider.currentStep > 0)
            TextButton(
              onPressed: () => provider.previousStep(),
              child: Text(
                'Atrás',
                style: GoogleFonts.poppins(
                  color: RocketColors.primary,
                  fontSize: 16,
                ),
              ),
            )
          else
            const SizedBox(width: 80),
          ElevatedButton(
            onPressed: canContinue ? () => provider.nextStep() : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: RocketColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: Text(
              'Continuar',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return '¿Cuál es tu combo o producto estrella en McDonald\'s?';
      case 1:
        return '¿Qué postre es tu debilidad?';
      case 2:
        return 'Si McDonald\'s te regalara algo... ¿qué preferirías?';
      case 3:
        return '¿Para quién sueles comprar en McDonald\'s?';
      case 4:
        return '¿Qué sabores te hacen decir "¡qué rico!"?';
      case 5:
        return '¿Por qué no vienes más seguido a McDonald\'s?';
      case 6:
        return '¿Qué tipo de sorpresas te gustaría recibir?';
      case 7:
        return '¿Qué acompañamiento prefieres?';
      default:
        return '';
    }
  }

  List<String> _getStepOptions(int step) {
    switch (step) {
      case 0:
        return [
          'Big Mac',
          'McNuggets',
          'Cuarto de libra',
          'McPollo',
          'Grand Big Mac',
          'McFlurry',
        ];
      case 1:
        return [
          'Sundae',
          'McFlurry',
          'Pastel',
          'Cono',
          'Apple Pie',
          'Brownies',
        ];
      case 2:
        return [
          'Un helado',
          'Una hamburguesa',
          'Papas gratis',
          'Refill de soda',
          'Juguete',
          'Postre',
        ];
      case 3:
        return [
          'Para mí',
          'Para mi familia',
          'Para mis hijos',
          'Para mi pareja',
          'Para compartir',
          'Para llevar',
        ];
      case 4:
        return ['Dulces', 'Salados', 'Picantes', 'BBQ', 'Ranch', 'Buffalo'];
      case 5:
        return [
          'Falta de tiempo',
          'Precio',
          'Distancia',
          'Falta de promociones',
          'Prefiero cocinar',
          'Dieta',
        ];
      case 6:
        return [
          'Cupones exclusivos',
          'Puntos extra',
          'Regalos sorpresa',
          'Productos gratis',
          'Descuentos especiales',
          'Acceso anticipado',
        ];
      case 7:
        return [
          'Papas',
          'Ensalada',
          'Aros de cebolla',
          'Refresco',
          'Postre',
          'Sin acompañamiento',
        ];
      default:
        return [];
    }
  }
}
