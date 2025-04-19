import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:McDonalds/models/survey_model.dart';

class SurveyService {
  static const String baseUrl = 'http://192.168.1.71:3002';

  static Future<bool> submitSurvey(Survey survey) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mcdonalds-survey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(survey.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error submitting survey: $e');
      return false;
    }
  }
}
