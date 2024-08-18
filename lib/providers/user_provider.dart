import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/services/user_apiservice.dart'; // Make sure to import your UserApiService
import 'package:vervevista/model/user_model.dart';
class UserProvider with ChangeNotifier {
String? _userId =''; // Ensure _userId is not null
  List<User> _advisors = [];
  User? _advisor;
bool _isLoading = false;
  String? _error;
  String _username = '';
  String _password = '';
    Map<String, dynamic>? _bookingResult;
  Map<String, dynamic>? get bookingResult => _bookingResult;

  User? _user;
  String get userId => _userId??"";
  String get username => _username;
  String get password => _password;
List<User> get advisors => _advisors;
  User? get advisor => _advisor;
  bool get isLoading => _isLoading;
  String? get error => _error;
    String? _errorMessage = '';
    String? get errorMessage => _errorMessage;

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


   Future<void> signupAdvisor({
    required String username,
    required String password,
    required String name,
    required String specialization,
    required double hourlyRate,
    required List<String> availability,
    String? profilePicture,
    String? servicesOffered,
    String? consultationPackageName,
    double? consultationPackagePrice,
    String? consultationPackageDescription,
  }) async {
    try {
      final result = await UserApiService.signupAdvisor(
        username: username,
        password: password,
        name: name,
        specialization: specialization,
        hourlyRate: hourlyRate,
        availability: availability,
        profilePicture: profilePicture,
        servicesOffered: servicesOffered,
        consultationPackageName: consultationPackageName,
        consultationPackagePrice: consultationPackagePrice,
        consultationPackageDescription: consultationPackageDescription,
      );

      if (result.containsKey('data')) {
        _userId = result['data']['_id'] ?? '';  // Update _userId based on response
        print('Advisor signup successful: ${result['data']}');
        notifyListeners();
      } else if (result.containsKey('error')) {
        print('Advisor signup error: ${result['error']}');
      }
    } catch (e) {
      print('Failed to sign up advisor: ${e.toString()}');
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


Future<String?> bookAdvisor({
  required String userId,
  required String advisorId,
  required String bookingDate,
  required String communicationMethod,
}) async {
  try {
    final result = await UserApiService.bookAdvisor(
      userId: userId,
      advisorId: advisorId,
      bookingDate: bookingDate,
      communicationMethod: communicationMethod,
    );

     if (result is Map<String, dynamic> && result.containsKey('bookingId')) {
      final bookingId = result['bookingId'] as String;
      print('Booking ID: $bookingId'); // For debugging purposes
      return bookingId; // Return the bookingId
    } else if (result is Map<String, dynamic> && result.containsKey('error')) {
      print('Booking error: ${result['error']}');
      return null;
    } else {
      print('No ID found');
    }
  } catch (e) {
    print('Failed to book advisor: ${e.toString()}');
    return null;
  }
  return null;
}



  // Fetch Advisor by ID
Future<void> fetchAdvisorById(String advisorId) async {
  print('Fetching advisor by ID: $advisorId');
  try {
    final response = await UserApiService.fetchAdvisorById(advisorId);
    print('API response: $response');

    if (response.containsKey('error')) {
      _errorMessage = response['error'];
      _advisor = null;
      print('Error: $_errorMessage');
    } else {
      _advisor = User.fromJson(response['data']);
      _errorMessage = null;
      print('Fetched advisor data: ${_advisor.toString()}');
    }

    notifyListeners();
  } catch (e) {
    _errorMessage = e.toString();
    _advisor = null;
    print('Exception: $_errorMessage');
    notifyListeners();
  }
}

Future<void> makePayment({
    required String bookingId,
    required double amount,
    required String cardNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await UserApiService.makePayment(
        bookingId: bookingId,
        amount: amount,
        cardNumber: cardNumber,
      );

      if (response.containsKey('error')) {
        _errorMessage = response['error'];
      } else {
        // Handle success, if needed
        _errorMessage = null;
      }
    } catch (e) {
      _errorMessage = 'Failed to make payment: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   Future<void> addRating({
    required String advisorId,
    required int rating,
    String? comment,
  }) async {
    try {
      final success = await UserApiService().addRating(
        userId: _userId!,
        advisorId: advisorId,
        rating: rating,
        comment: comment,
      );

      if (success) {
        // Rating added successfully, you can update the UI or notify listeners here
        print('Rating added successfully.');
      } else {
        // Handle failure
        print('Failed to add rating.');
        _errorMessage = 'Failed to add rating.';
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred while adding rating: $e');
      _errorMessage = 'Exception occurred: $e';
    }

    notifyListeners();
  }

}
