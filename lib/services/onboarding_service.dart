import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:McDonalds/models/onboarding_form.dart';

class OnboardingService {
  static const String baseUrl = 'http://192.168.1.71:3002';

  // Obtener todos los formularios
  static Future<List<OnboardingForm>> getAllForms() async {
    final response = await http.get(Uri.parse('$baseUrl/onboarding-forms'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => OnboardingForm.fromJson(json)).toList();
    }
    throw Exception('Error al obtener formularios');
  }

  // Crear nuevo formulario
  static Future<bool> createForm(OnboardingForm form) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/onboarding-forms'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(form.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al crear formulario: $e');
    }
  }

  static Future<Map<String, dynamic>> submitForm(OnboardingForm form) async {
    try {
      // Convertir las respuestas al formato esperado por la API
      final Map<String, dynamic> apiData = {
        'favoriteProducts': [form.answers['step_0']], // Producto estrella
        'favoriteDessert': form.answers['step_1'] ?? '', // Postre favorito
        'preferredGift': form.answers['step_2'] ?? '', // Regalo preferido
        'purchaseFor': [form.answers['step_3']], // Para quién compra
        'favoriteFlavors': [form.answers['step_4']], // Sabores favoritos
        'visitObstacle':
            form.answers['step_5'] ?? '', // Por qué no viene más seguido
        'preferredSurprises': [form.answers['step_6']], // Sorpresas preferidas
        'preferredSide':
            form.answers['step_7'] ?? '', // Acompañamiento preferido
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/answers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(apiData),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      }
      throw Exception('Error al enviar encuesta: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al enviar encuesta: $e');
    }
  }

  static Future<Map<String, dynamic>> getSurvey(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/answers/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Encuesta no encontrada');
      }
      throw Exception('Error al obtener encuesta');
    } catch (e) {
      throw Exception('Error al obtener encuesta: $e');
    }
  }

  static Future<Map<String, dynamic>> updateSurvey(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/answers/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Error al actualizar encuesta');
    } catch (e) {
      throw Exception('Error al actualizar encuesta: $e');
    }
  }
}
