import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  static const String baseUrl =
      'https://swd-project-api.onrender.com/api';

  Future<Map<String, dynamic>> getStats(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/stats'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stats');
    }
  }

  Future<List<dynamic>> getAlerts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/alerts?limit=5'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"];
    } else {
      throw Exception('Failed to load alerts');
    }
  }
}