import 'package:flutter/material.dart';
import '../models/onboarding_form.dart';
import '../services/storage_service.dart';
import '../services/onboarding_service.dart';
import '../services/navigation_service.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';

class OnboardingProvider with ChangeNotifier {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      NavigationService.navigatorKey;
  OnboardingForm? _form;
  bool _isCompleted = false;
  int _currentStep = 0;
  bool _showThankYou = false;
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;
  bool _shouldSubmitToServer = false;
  final Map<int, String> _selectedOptions = {};

  bool get isCompleted => _isCompleted;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  OnboardingForm? get form => _form;
  int get currentStep => _currentStep;
  bool get showThankYou => _showThankYou;
  String? get error => _error;

  OnboardingProvider() {
    _loadSavedForm();
  }

  Future<void> _loadSavedForm() async {
    try {
      _form = StorageService.getOnboardingForm();
      _isCompleted = _form != null;
      if (_form != null) {
        // Recuperar las opciones seleccionadas del formulario guardado
        _form!.answers.forEach((key, value) {
          if (key.startsWith('step_')) {
            final step = int.tryParse(key.split('_')[1]);
            if (step != null) {
              _selectedOptions[step] = value.toString();
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error al cargar el formulario: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> submitForm(OnboardingForm form) async {
    try {
      _form = form;
      await StorageService.saveOnboardingForm(form);
      _isCompleted = true;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error al guardar el formulario: $e');
      return false;
    }
  }

  Future<void> resetForm() async {
    try {
      await StorageService.clearOnboardingForm();
      _form = null;
      _isCompleted = false;
      _currentStep = 0;
      _selectedOptions.clear();
      _showThankYou = false;
      _error = null;
      _shouldSubmitToServer = false;
    } catch (e) {
      debugPrint('Error al resetear el formulario: $e');
    } finally {
      notifyListeners();
    }
  }

  bool isOptionSelected(int step, String option) {
    return _selectedOptions[step] == option;
  }

  bool canContinue() {
    return _selectedOptions[_currentStep]?.isNotEmpty ?? false;
  }

  void toggleOption(int step, String option) {
    if (_selectedOptions[step] == option) {
      _selectedOptions[step] = ''; // Deseleccionar
    } else {
      _selectedOptions[step] = option; // Selección única
    }
    notifyListeners();
  }

  Future<void> nextStep() async {
    if (_currentStep < 7 && canContinue()) {
      final shouldContinue = await showContinueDialog(
        rootNavigatorKey.currentContext!,
      );
      if (!shouldContinue) return;

      _currentStep++;
      _error = null;
    } else if (_currentStep == 7 && canContinue()) {
      _showThankYou = true;
      _saveFormLocally();
    }
    notifyListeners();
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _showThankYou = false;
      _error = null;
    }
    notifyListeners();
  }

  Future<void> _saveFormLocally() async {
    if (!canContinue() || _isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final Map<String, dynamic> answersMap = {};
      _selectedOptions.forEach((step, option) {
        if (option.isNotEmpty) {
          answersMap['step_$step'] = option;
        }
      });

      final formData = OnboardingForm(
        answers: answersMap,
        completedAt: DateTime.now(),
      );

      // Solo guardamos localmente sin intentar enviar
      final savedLocally = await submitForm(formData);
      if (!savedLocally) {
        _error = 'Error al guardar el formulario localmente';
      }
      // No establecemos _shouldSubmitToServer aquí
    } catch (e) {
      _error = 'Error al procesar el formulario: $e';
      debugPrint('Error al guardar formulario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setShouldSubmitToServer(bool value) {
    _shouldSubmitToServer = value;
    notifyListeners();
  }

  Future<bool> submitFormToServer(BuildContext context) async {
    if (!_shouldSubmitToServer || _form == null || _isLoading) return false;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token != null) {
        final success = await OnboardingService.submitForm(_form!, token);
        if (success) {
          _shouldSubmitToServer =
              false; // Reseteamos el flag después de enviar exitosamente
          notifyListeners();
          return true;
        }
        _error =
            'Error al enviar al servidor, los datos se guardarán localmente';
        return false;
      }
      return false;
    } catch (e) {
      _error = 'Error al enviar al servidor: $e';
      debugPrint('Error al enviar formulario: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Este método se puede llamar al iniciar sesión
  Future<void> checkAndSubmitSavedForm(BuildContext context) async {
    if (_form != null) {
      setShouldSubmitToServer(true);
      await submitFormToServer(context);
    }
  }

  Future<bool> showContinueDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('¿Desea continuar?'),
            content: const Text('¿Desea continuar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDA291C),
                ),
                child: const Text('Sí', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
    return result ?? false;
  }

  Future<void> completeOnboarding(BuildContext context) async {
    if (!canContinue() || _isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      //notifyListeners();

      final Map<String, dynamic> answersMap = {};
      _selectedOptions.forEach((step, option) {
        if (option.isNotEmpty) {
          answersMap['step_$step'] = option;
        }
      });

      final formData = OnboardingForm(
        answers: answersMap,
        completedAt: DateTime.now(),
      );

      // Guardar localmente
      final savedLocally = await submitForm(formData);
      if (!savedLocally) {
        _error = 'Error al guardar el formulario localmente';
        return;
      }

      // Intentar enviar al servidor
      final success = await submitFormToServer(context);
      if (!success) {
        setShouldSubmitToServer(true); // Se intentará enviar más tarde
      }

      // Marcar como completado incluso si falla el envío al servidor
      _isCompleted = true;
    } catch (e) {
      _error = 'Error al completar el onboarding: $e';
      debugPrint('Error al completar onboarding: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
