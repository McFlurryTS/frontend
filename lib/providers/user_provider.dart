import 'package:flutter/material.dart';
import 'package:McDonalds/models/user_model.dart';
import 'package:McDonalds/services/storage_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _token;
  String? _tokenType;
  bool _isInitialized = false;

  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isInitialized => _isInitialized;

  Map<String, String> get authHeaders => {
    'Authorization': '$_tokenType $_token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  UserProvider() {
    _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    final authData = await StorageService.getAuthData();
    if (authData != null) {
      _token = authData['token'];
      _tokenType = authData['token_type'];
      notifyListeners();
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Intentando login con email: $username');
      final response = await http.post(
        Uri.parse('http://54.236.59.113/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': username, 'password': password}),
      );

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['access_token'];
        _tokenType = data['token_type'];

        if (data['user'] != null) {
          _currentUser = UserProfile(
            id: data['user']['id'].toString(),
            name: data['user']['username'],
            email: data['user']['email'],
          );
        }

        // Guardar datos de autenticación localmente
        await StorageService.saveAuthData(_token!, _tokenType!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error en login: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _tokenType = null;
    _currentUser = null;
    await StorageService.clearAuthData();
    notifyListeners();
  }

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
        photoUrl: null,
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
