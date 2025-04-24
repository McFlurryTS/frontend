import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:McDonalds/models/onboarding_form.dart';
import 'package:flutter/material.dart';

class OnboardingService {
  static const String baseUrl = 'http://54.236.59.113';

  static Future<bool> submitForm(OnboardingForm form, String token) async {
    try {
      final Map<String, dynamic> apiData = {
        'answers': [
          {'question_id': 1, 'answer': form.answers['step_0'] ?? ''},
          {'question_id': 2, 'answer': form.answers['step_1'] ?? ''},
          {'question_id': 3, 'answer': form.answers['step_2'] ?? ''},
          {'question_id': 4, 'answer': form.answers['step_3'] ?? ''},
          {'question_id': 5, 'answer': form.answers['step_4'] ?? ''},
          {'question_id': 6, 'answer': form.answers['step_5'] ?? ''},
          {'question_id': 7, 'answer': form.answers['step_6'] ?? ''},
          {'question_id': 8, 'answer': form.answers['step_7'] ?? ''},
        ],
      };

      debugPrint('Enviando formulario con token: $token');
      debugPrint('Datos a enviar: ${json.encode(apiData)}');

      final response = await http.post(
        Uri.parse('$baseUrl/api/answers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(apiData),
      );

      debugPrint('Respuesta del servidor: ${response.statusCode}');
      debugPrint('Cuerpo de la respuesta: ${response.body}');

      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error al enviar encuesta: $e');
      return false;
    }
  }
}
