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

static Future<Map<String, dynamic>> signupAdvisor({
    required String username,
    required String password,
    required String name,
    required String specialization,
    required double hourlyRate,
    required List<String> availability,
    String? profilePicture,  // Optional
    String? servicesOffered,  // Optional
    String? consultationPackageName,  // Flattened
    double? consultationPackagePrice,  // Changed to double
    String? consultationPackageDescription,  // Flattened
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
        'profilePicture': profilePicture,
        'servicesOffered': servicesOffered,
        'consultationPackageName': consultationPackageName,
        'consultationPackagePrice': consultationPackagePrice,
        'consultationPackageDescription': consultationPackageDescription,
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


   static Future<http.Response> fetchAdvisors() async {
    final response = await http.get(Uri.parse('$baseUrl/listadvisors'));

    if (response.statusCode == 200) {
      return response; // Return the raw response for further processing
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


   // Fetch Advisor by ID
  static Future<Map<String, dynamic>> fetchAdvisorById(String advisorId) async {
    try {
      if (advisorId == null || advisorId.isEmpty) {
        throw Exception('Advisor ID is empty');
      }

      final response = await http.get(Uri.parse("$baseUrl/advisor/$advisorId"));
      print('API Response: ${response.body}');


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data == null) {
          throw Exception('Received empty or null data');
        }

        return {
          'data': data,
        };
      } else {
        final responseJson = jsonDecode(response.body);
        throw Exception('Failed to fetch advisor: ${responseJson['error']}');
      }
    } catch (e) {
      print('Failed to fetch advisor: ${e.toString()}');
      throw Exception('Failed to fetch advisor: ${e.toString()}');
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

  // Book an Advisor
static Future<Map<String, dynamic>> bookAdvisor({
  required String userId,
  required String advisorId,
  required String bookingDate,
  required String communicationMethod,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/advisors/book'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      'advisorId': advisorId,
      'bookingDate': bookingDate,
      'communicationMethod': communicationMethod,
    }),
  );
 return json.decode(response.body) as Map<String, dynamic>;


}



static Future<Map<String, dynamic>> makePayment({
  required String bookingId,
  required double amount,
  required String cardNumber,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/payment'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'bookingId': bookingId,
      'amount': amount,
      'cardNumber': cardNumber,
    }),
  );

  return _handleResponse(response);
}

  Future<bool> addRating({
    required String userId,
    required String advisorId,
    required int rating,
    String? comment,
  }) async {
    final url = Uri.parse('$baseUrl/advisors/rate/$userId/$advisorId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'rating': rating,
        if (comment != null) 'comment': comment,  // Include comment if provided
      }),
    );

    if (response.statusCode == 201) {
      // Rating added successfully
      return true;
    } else {
      // Handle error
      print('Failed to add rating: ${response.body}');
      return false;
    }
  }


  static Future<Map<String, dynamic>> reportAdvisor({
  required String reporterId,
  required String advisorId,
  required String description,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/advisors/report'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'reporter': reporterId,
      'advisor': advisorId,
      'description': description,
    }),
  );

  return _handleResponse(response);
}


  // Send message from user to advisor
  static Future<Map<String, dynamic>> sendMessageFromUserToAdvisor({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sendMessage/userToAdvisor'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
      }),
    );
    return _handleResponse(response);
  }

  // Send message from advisor to user
  static Future<Map<String, dynamic>> sendMessageFromAdvisorToUser({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sendMessage/advisorToUser'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
      }),
    );
    return _handleResponse(response);
  }

static Future<List<dynamic>> fetchMessagesBetweenUserAndAdvisor({
  required String userId,
  required String advisorId,
}) async {
  final response = await http.get(
    Uri.parse('$baseUrl/messages/user/$userId/advisor/$advisorId'),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    final responseJson = jsonDecode(response.body);
    throw Exception('Failed to fetch messages: ${responseJson['error']}');
  }
}

  // Fetch messages between advisor and user
  static Future<List<dynamic>> fetchMessagesBetweenAdvisorAndUser({
    required String advisorId,
    required String userId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/advisor/$advisorId/user/$userId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      final responseJson = jsonDecode(response.body);
      throw Exception('Failed to fetch messages: ${responseJson['error']}');
    }
  }


  static Future<List<Map<String, dynamic>>> fetchSuccessfulPaymentsAndUsers(String advisorId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/advisor/$advisorId/payments'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Convert the List<dynamic> to List<Map<String, dynamic>>
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        final responseJson = jsonDecode(response.body);
        throw Exception('Failed to fetch successful payments and users: ${responseJson['error']}');
      }
    } catch (e) {
      throw Exception('Failed to fetch successful payments and users: ${e.toString()}');
    }
  }



}
