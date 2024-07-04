import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8089';

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/serre/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      await setCurrentUser(body['id'], body['role']);
      return response;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> setCurrentUser(int userId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString('userRole', role);
  }

  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<String?> getCurrentUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  Future<http.Response> getSerresByUserId() async {
    final userId = await getCurrentUserId();
    if (userId == null) {
      throw Exception('User ID is not available');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/serre/serres/$userId'),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load serres');
    }
  }

  Future<http.Response> getLastSerre() async {
    final userId = await getCurrentUserId();
    if (userId == null) {
      throw Exception('User ID is not available');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/serre/latest/$userId'),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load last serre');
    }
  }

  Future<http.Response> addUser(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/serre/addUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to add user');
    }
  }

  Future<http.Response> getSerreByUser() async {
    final userId = await getCurrentUserId();
    final userRole = await getCurrentUserRole();

    if (userId == null || userRole == null) {
      throw Exception('User ID or role is not available');
    }

    final url = userRole == 'ADMIN'
        ? '$baseUrl/serre/serre/findAllSerre'
        : '$baseUrl/serre/serre/findIdSerreByUser/$userId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load serre');
    }
  }

  Future<http.Response> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/serre/AllUser'),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userRole');
  }
}
