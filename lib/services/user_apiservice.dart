import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/model/user_model.dart';

class UserApiService {
  static const String baseUrl = "http://10.0.2.2:3000/api";
  static const String contactInfoKey = 'contact_info'; // SharedPreferences key
  static const String idKey = 'id'; // SharedPreferences key
  static const String otpKey = 'otp'; // SharedPreferences key

// Sign Up User
static Future<Map<String, dynamic>> signup({
  required String username,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/signup'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'password': password,
    }),
  );
  return _handleResponse(response);
}

  // Sign In User
  static Future<Map<String, dynamic>> signin({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    return _handleResponse(response);
  }

  // Sign Up Advisor
  static Future<Map<String, dynamic>> signupAdvisor({
    required String username,
    required String password,
    required String name,
    required String specialization,
    required double hourlyRate,
    required String availability,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signupAd'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'name': name,
        'specialization': specialization,
        'hourlyRate': hourlyRate,
        'availability': availability,
      }),
    );
    return _handleResponse(response);
  }

  // Sign In Advisor
  static Future<Map<String, dynamic>> signinAdvisor({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signinAd'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    return _handleResponse(response);
  }

  // Helper function to handle response
static Map<String, dynamic> _handleResponse(http.Response response) {
  final Map<String, dynamic> result = {};
  if (response.statusCode == 200 || response.statusCode == 201) {
    if (response.body.isNotEmpty) {
      try {
        result['data'] = jsonDecode(response.body);
      } catch (e) {
        result['error'] = 'Invalid JSON response: $e';
      }
    } else {
      result['error'] = 'Empty response';
    }
  } else {
    if (response.body.isNotEmpty) {
      try {
        result['error'] = jsonDecode(response.body);
      } catch (e) {
        result['error'] = 'Invalid JSON error response: $e';
      }
    } else {
      result['error'] = 'Unexpected error with empty response';
    }
  }
  return result;
}



  static Future<User> fetchUserProfileById(String userId) async {
  try {
    if (userId == null || userId.isEmpty) { // Add null check here
      throw Exception('User ID is empty');
    }

    final response = await http.get(Uri.parse("$baseUrl/profile/$userId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data == null) {
        throw Exception('Received empty or null data');
      }

      return User.fromJson(data);
    } else {
      final responseJson = jsonDecode(response.body);
      throw Exception('Failed to fetch user profile: ${responseJson['error']}');
    }
  } catch (e) {
    throw Exception('Failed to fetch user profile: ${e.toString()}');
  }
}


// Fetch List of Advisors
static Future<List<User>> fetchAdvisors() async {
  final response = await http.get(Uri.parse('$baseUrl/listadvisors'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((json) => User.fromJson(json)).toList();
  } else {
    final responseJson = jsonDecode(response.body);
    throw Exception('Failed to fetch advisors: ${responseJson['error']}');
  }
}


  static Future<List<User>> searchAdvisors(String keyword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/advisors/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'keyword': keyword}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      final responseJson = jsonDecode(response.body);
      throw Exception('Failed to search advisors: ${responseJson['error']}');
    }
  }


  // Fetch Advisors Sorted by Rating Descending
  static Future<List<User>> fetchAdvisorsSortedByRatingDesc() async {
    final response = await http.get(Uri.parse('$baseUrl/advisors/sort/desc'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      final responseJson = jsonDecode(response.body);
      throw Exception('Failed to fetch sorted advisors: ${responseJson['error']}');
    }
  }
}
