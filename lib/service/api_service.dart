import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final String apiUrl = "https://flutter-amr.noviindus.in/api/";
  List<Map<String, dynamic>> patients = [];
  Future<String?> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/Login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        return token;
      } else {
        print('Failed to login. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future<void> fetchData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/PatientList'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Data received: ${response.body}');
        patients =
            data.map((patient) => patient as Map<String, dynamic>).toList();
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
