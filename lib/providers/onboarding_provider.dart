import 'package:flutter/material.dart';
import '../models/onboarding_form.dart';
import '../services/storage_service.dart';
import '../services/onboarding_service.dart';

class OnboardingProvider with ChangeNotifier {
  OnboardingForm? _form;
  bool _isCompleted = false;
  int _currentStep = 0;
  bool _showThankYou = false;

  // Mapa para almacenar las opciones seleccionadas por paso
  final Map<int, List<String>> _selectedOptions = {};

  bool get isCompleted => _isCompleted;
  OnboardingForm? get form => _form;
  int get currentStep => _currentStep;
  bool get showThankYou => _showThankYou;

  OnboardingProvider() {
    _loadSavedForm();
  }

  Future<void> _loadSavedForm() async {
    _form = StorageService.getOnboardingForm();
    _isCompleted = _form != null;
    notifyListeners();
  }

  Future<void> submitForm(OnboardingForm form) async {
    _form = form;
    await StorageService.saveOnboardingForm(form);
    _isCompleted = true;
    notifyListeners();
  }

  Future<void> resetForm() async {
    await StorageService.clearOnboardingForm();
    _form = null;
    _isCompleted = false;
    _currentStep = 0;
    _selectedOptions.clear();
    _showThankYou = false;
    notifyListeners();
  }

  // Método para verificar si una opción está seleccionada en un paso específico
  bool isOptionSelected(int step, String option) {
    return _selectedOptions[step]?.contains(option) ?? false;
  }

  // Método para seleccionar/deseleccionar una opción en un paso específico
  void toggleOption(int step, String option) {
    // Reiniciamos la lista para este paso (selección única)
    _selectedOptions[step] = [option];
    notifyListeners();
  }

  // Métodos para la navegación del onboarding
  void nextStep() {
    if (_currentStep < 7) {
      _currentStep++;
    } else {
      _showThankYou = true;
    }
    notifyListeners();
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _showThankYou = false;
    }
    notifyListeners();
  }

  // Método para completar el onboarding
  Future<void> completeOnboarding() async {
    // Verificar que tenemos todas las respuestas necesarias
    final Map<String, dynamic> answersMap = {};

    // Iterar sobre cada paso y asignar las respuestas al formato correcto
    _selectedOptions.forEach((step, options) {
      if (options.isNotEmpty) {
        final String option =
            options[0]; // Tomamos la primera opción ya que es selección única
        switch (step) {
          case 0:
            answersMap['step_$step'] = option; // Producto estrella
            break;
          case 1:
            answersMap['step_$step'] = option; // Postre favorito
            break;
          case 2:
            answersMap['step_$step'] = option; // Regalo preferido
            break;
          case 3:
            answersMap['step_$step'] = option; // Para quién compras
            break;
          case 4:
            answersMap['step_$step'] = option; // Sabores favoritos
            break;
          case 5:
            answersMap['step_$step'] = option; // Por qué no vienes más seguido
            break;
          case 6:
            answersMap['step_$step'] = option; // Tipo de sorpresas
            break;
          case 7:
            answersMap['step_$step'] = option; // Acompañamiento preferido
            break;
        }
      }
    });

    // Crear un formulario con las respuestas
    final formData = OnboardingForm(
      answers: answersMap,
      completedAt: DateTime.now(),
    );

    // Guardar localmente
    await submitForm(formData);

    try {
      // Enviar a la API
      final result = await OnboardingService.submitForm(formData);
      debugPrint(
        'Formulario enviado a la API exitosamente: ${result['status']}',
      );
    } catch (e) {
      debugPrint('Error al enviar formulario a la API: $e');
      // El formulario se guardó localmente de todos modos
    }
  }
}
