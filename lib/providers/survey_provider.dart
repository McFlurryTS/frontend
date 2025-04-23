import 'package:flutter/foundation.dart';
import 'package:McDonalds/models/survey_model.dart';
import 'package:McDonalds/services/survey_service.dart';

class SurveyProvider with ChangeNotifier {
  bool _hasCompletedSurvey = false;
  int _currentStep = 0;
  final Map<String, dynamic> _formData = {};
  final Map<int, Set<String>> _selectedOptions = {};

  bool get hasCompletedSurvey => _hasCompletedSurvey;
  int get currentStep => _currentStep;
  Map<String, dynamic> get formData => _formData;

  void init() {
    _hasCompletedSurvey = false;
    _currentStep = 0;
    _formData.clear();
    _selectedOptions.clear();
    notifyListeners();
  }

  bool isOptionSelected(int step, String option) {
    return _selectedOptions[step]?.contains(option) ?? false;
  }

  void toggleOption(int step, String option) {
    _selectedOptions[step] ??= {};

    if (_isSingleChoiceStep(step)) {
      _selectedOptions[step]?.clear();
      _selectedOptions[step]?.add(option);
    } else {
      if (_selectedOptions[step]!.contains(option)) {
        _selectedOptions[step]!.remove(option);
      } else {
        _selectedOptions[step]!.add(option);
      }
    }

    _updateFormData(step);
    notifyListeners();
  }

  bool _isSingleChoiceStep(int step) {
    return [2, 5, 7].contains(step); // Pasos que requieren una sola selección
  }

  void _updateFormData(int step) {
    final options = _selectedOptions[step]?.toList() ?? [];
    switch (step) {
      case 0:
        _formData['favoriteProducts'] = options;
        break;
      case 1:
        _formData['favoriteDessert'] = options;
        break;
      case 2:
        _formData['preferredGift'] = options.first;
        break;
      case 3:
        _formData['purchaseFor'] = options;
        break;
      case 4:
        _formData['favoriteFlavors'] = options;
        break;
      case 5:
        _formData['visitObstacle'] = options.first;
        break;
      case 6:
        _formData['preferredSurprises'] = options;
        break;
      case 7:
        _formData['preferredSide'] = options.first;
        break;
    }
  }

  void nextStep() {
    if (_validateCurrentStep() && _currentStep < 7) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  bool _validateCurrentStep() {
    return _selectedOptions[_currentStep]?.isNotEmpty ?? false;
  }

  Future<bool> submitForm() async {
    if (!_validateCurrentStep()) return false;

    try {
      final survey = Survey(
        favoriteProducts: List<String>.from(
          _formData['favoriteProducts'] ?? [],
        ),
        favoriteDessert:
            (_formData['favoriteDessert'] as List<String>?)?.join(', ') ?? '',
        preferredGift: _formData['preferredGift'] ?? '',
        purchaseFor: List<String>.from(_formData['purchaseFor'] ?? []),
        favoriteFlavors: List<String>.from(_formData['favoriteFlavors'] ?? []),
        visitObstacle: _formData['visitObstacle'] ?? '',
        preferredSurprises: List<String>.from(
          _formData['preferredSurprises'] ?? [],
        ),
        preferredSide: _formData['preferredSide'] ?? '',
      );

      final success = await SurveyService.submitSurvey(survey);
      if (success) {
        _hasCompletedSurvey = true;
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error submitting survey: $e');
      return false;
    }
  }
}
