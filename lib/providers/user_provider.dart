import 'package:flutter/material.dart';
import 'package:McDonalds/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _currentUser;
  bool _isLoading = false;

  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Simular carga de usuario (aquí podrías conectar con tu backend)
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 500));

      // Usuario de ejemplo
      _currentUser = UserProfile(
        id: '1',
        name: 'Usuario de Ejemplo',
        email: 'usuario@ejemplo.com',
        photoUrl: null, // Aquí podrías poner una URL de foto por defecto
        phoneNumber: '+52 (123) 456-7890',
        address: 'Calle Ejemplo #123, Ciudad de México',
      );
    } catch (e) {
      debugPrint('Error cargando usuario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = updatedProfile;
    } catch (e) {
      debugPrint('Error actualizando perfil: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _currentUser = _currentUser!.copyWith(hasNotificationsEnabled: enabled);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
