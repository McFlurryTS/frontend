import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/recommendation.dart';

class RecommendationService {
  final String baseUrl;
  final String token;

  RecommendationService({required this.baseUrl, required this.token});

  Future<List<Recommendation>> getRecommendations() async {
    try {
      final url = Uri.parse('$baseUrl/api/get-recommendation');
      debugPrint('RecommendationService - Haciendo petición a: $url');
      debugPrint('RecommendationService - Token: $token');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('RecommendationService - Status Code: ${response.statusCode}');
      debugPrint('RecommendationService - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final recommendations =
            data.map((json) => Recommendation.fromJson(json)).toList();
        debugPrint(
          'RecommendationService - Recomendaciones de API: ${recommendations.length}',
        );
        return recommendations;
      } else {
        debugPrint(
          'RecommendationService - Usando datos de demostración por error en API',
        );
        return _getDemoRecommendations();
      }
    } catch (e, stackTrace) {
      debugPrint('RecommendationService - Error: $e');
      debugPrint('RecommendationService - StackTrace: $stackTrace');
      debugPrint(
        'RecommendationService - Usando datos de demostración por excepción',
      );
      return _getDemoRecommendations();
    }
  }

  List<Recommendation> _getDemoRecommendations() {
    final demoData = [
      Recommendation(
        id: 'demo1',
        message: '¿Te gustaría probar nuestra Cajita Feliz con hamburguesa?',
        category: 'HAPPY_MEAL',
        options: [
          ProductOption(
            id: 'happy1',
            name: 'Cajita Feliz con Hamburguesa',
            description:
                'Incluye hamburguesa, papas pequeñas, bebida y juguete',
            image: 'assets/happy/happy_meal_chica.png',
            price: 89.0,
          ),
        ],
      ),
      Recommendation(
        id: 'demo2',
        message: '¿Qué tal una Cajita Feliz con McNuggets?',
        category: 'HAPPY_MEAL',
        options: [
          ProductOption(
            id: 'happy2',
            name: 'Cajita Feliz con McNuggets',
            description:
                'Incluye 4 McNuggets, papas pequeñas, bebida y juguete',
            image: 'assets/happy/happy_meal_grande.png',
            price: 99.0,
          ),
        ],
      ),
    ];
    debugPrint(
      'RecommendationService - Datos de demostración generados: ${demoData.length} recomendaciones',
    );
    return demoData;
  }
}
