import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
    'https://10.0.2.2:7070/api';


  static String? _token;

  // ================= LOGIN =================
 static Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  ).timeout(const Duration(seconds: 10));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // lưu token nếu muốn dùng sau
    _token = data['token'];

    return data;
  } else {
    throw Exception('Login failed: ${response.statusCode} - ${response.body}');
  }
}


  // ================= REGISTER =================
  static Future<void> register({
    required String email,
    required String fullName,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/createAccount'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'orgId': 1,
        'siteId': 1,
        'fullName': fullName,
        'email': email,
        'roleId': 1,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Register failed: ${response.body}');
    }
  }

  // ================= LOGOUT =================
  static void logout() {
    _token = null;
  }

  static String? get token => _token;
}
