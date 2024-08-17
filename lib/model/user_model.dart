import 'package:intl/intl.dart';
import 'package:vervevista/model/review_model.dart';

class User {
  String id;  // Unique identifier for the user
  String username;
  String password;  // In a real app, you would not store or manage passwords in this way
  String role;  // Should be either 'User' or 'Advisor'
  String? profilePicture;
  DateTime createdAt;

  // Advisor-specific fields
  String? name;  // Required if role is 'Advisor'
  String? specialization;  // Required if role is 'Advisor'
  double? hourlyRate;  // Required if role is 'Advisor'
  List<String>? availability;  // Required if role is 'Advisor'
  List<Review>? reviews;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    this.profilePicture,
    DateTime? createdAt,
    this.name,
    this.specialization,
    this.hourlyRate,
    this.availability,
    this.reviews,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructor to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',  // Ensure id is not null
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      profilePicture: json['profilePicture'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      name: json['name'],
      specialization: json['specialization'],
      hourlyRate: json['hourlyRate']?.toDouble(),
      availability: List<String>.from(json['availability'] ?? []),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e))
          .toList(),
    );
  }

  // Method to convert User to a JSON object
  Map<String, dynamic> toJson() {
    return {
      '_id': id,  // Include id in the JSON output
      'username': username,
      'password': password,
      'role': role,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
      'name': name,
      'specialization': specialization,
      'hourlyRate': hourlyRate,
      'availability': availability,
      'reviews': reviews?.map((e) => e.toJson()).toList(),
    };
  }
}
