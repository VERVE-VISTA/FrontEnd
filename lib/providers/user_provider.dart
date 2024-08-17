import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/services/user_apiservice.dart'; // Make sure to import your UserApiService
import 'package:vervevista/model/user_model.dart';
class UserProvider with ChangeNotifier {
String? _userId =''; // Ensure _userId is not null
  List<User> _advisors = [];
bool _isLoading = false;
  String? _error;
  String _username = '';
  String _password = '';
  User? _user;
  String get userId => _userId??"";
  String get username => _username;
  String get password => _password;
List<User> get advisors => _advisors;
  bool get isLoading => _isLoading;
  String? get error => _error;
    String _errorMessage = '';
    String get errorMessage => _errorMessage;

  // Method to handle user signup
 Future<void> signupUser({
    required String username,
    required String password,
  }) async {
    final result = await UserApiService.signup(
      username: username,
      password: password,
    );

    if (result.containsKey('data')) {
      // Handle successful signup response
      print('Signup successful: ${result['data']}');
      // Store user ID and other relevant data as needed
      _userId = result['data']['userId']; // Example of storing user ID
      _username = username;
      _password = password;
      notifyListeners();
    } else if (result.containsKey('error')) {
      // Handle signup error
      print('Signup error: ${result['error']}');
    }
  }

  // Method to handle user signin
  Future<void> signinUser({
  required String username,
  required String password,
}) async {
  final result = await UserApiService.signin(
    username: username,
    password: password,
  );

  if (result.containsKey('data')) {
    // Handle successful signin response
    final data = result['data'] as Map<String, dynamic>;

    // Check for null values
    _userId = data['userId'] ?? ''; // Default to empty string if null
    _username = username;
    _password = password;

    await saveUserDetailsLocally(); // Save details locally

    print('Signin successful: $data');
  } else if (result.containsKey('error')) {
    // Handle signin error
    print('Signin error: ${result['error']}');
  }
}


  // Method to handle advisor signup
  Future<void> signupAdvisor({
    required String username,
    required String password,
    required String name,
    required String specialization,
    required double hourlyRate,
    required String availability,
  }) async {
    final result = await UserApiService.signupAdvisor(
      username: username,
      password: password,
      name: name,
      specialization: specialization,
      hourlyRate: hourlyRate,
      availability: availability,
    );

    if (result.containsKey('data')) {
      // Handle successful advisor signup response
      print('Advisor signup successful: ${result['data']}');
    } else if (result.containsKey('error')) {
      // Handle advisor signup error
      print('Advisor signup error: ${result['error']}');
    }
  }

  // Method to handle advisor signin
  Future<void> signinAdvisor({
    required String username,
    required String password,
  }) async {
    final result = await UserApiService.signinAdvisor(
      username: username,
      password: password,
    );

    if (result.containsKey('data')) {
      // Handle successful advisor signin response
      final data = result['data'] as Map<String, dynamic>;
      _userId = data['userId'];
      _username = username;
      _password = password;

      await saveUserDetailsLocally(); // Save details locally

      print('Advisor signin successful: $data');
    } else if (result.containsKey('error')) {
      // Handle advisor signin error
      print('Advisor signin error: ${result['error']}');
    }
  }
  

  // Method to save user details locally
  Future<void> saveUserDetailsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', _userId??"");
    await prefs.setString('username', _username);
    await prefs.setString('password', _password);
    notifyListeners();
  }
    String getUserRole() {
    return _user?.role ?? '';
  }

Future<void> fetchUserProfileById(String userId) async {
  try {
    if (userId == null || userId.isEmpty) {
      throw Exception('User ID is empty or not found');
    }

    _user = await UserApiService.fetchUserProfileById(userId);
    notifyListeners();
  } catch (e) {
    throw Exception('Failed to fetch user profile: ${e.toString()}');
  }
}




  Future<void> fetchUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId') ?? '';
  }

  Future<String> fetchUserId() async {
  // Replace with your actual implementation to fetch userId from preferences
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId') ?? ''; // Return empty string if userId is not found
}

 Future<void> fetchAdvisors() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<User> fetchedAdvisors = await UserApiService.fetchAdvisors();
      _advisors = fetchedAdvisors;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }




  // Fetch Advisors Sorted by Rating Descending
  Future<void> fetchAdvisorsSortedByRatingDesc() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await UserApiService.fetchAdvisorsSortedByRatingDesc();
      _advisors = result;
      _errorMessage = ''; // Clear previous errors
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search Advisors by Keyword
  Future<void> searchAdvisors(String keyword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await UserApiService.searchAdvisors(keyword);
      _advisors = result;
      _errorMessage = ''; // Clear previous errors
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
