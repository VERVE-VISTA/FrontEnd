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
  List<String>? availability;  // Changed to List<String>
  List<Review>? reviews;
  String? servicesOffered;  // Required if role is 'Advisor'
  String? consultationPackageName;  // Flattened
  double? consultationPackagePrice;  // Changed to double
  String? consultationPackageDescription;  // Flattened

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
    this.servicesOffered,
    this.consultationPackageName,
    this.consultationPackagePrice,
    this.consultationPackageDescription,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructor to create a User from a JSON object

  // Method to convert User to a JSON object
 factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['_id'] ?? '',
    username: json['username'] ?? '',
    password: json['password'] ?? '',
    role: json['role'] ?? '',
    profilePicture: json['profilePicture'],
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    name: json['name'],
    specialization: json['specialization'],
    hourlyRate: json['hourlyRate']?.toDouble(),
    availability: (json['availability'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    reviews: (json['reviews'] as List<dynamic>?)
        ?.map((e) => Review.fromJson(e))
        .toList(),
    servicesOffered: json['servicesOffered'],
    consultationPackageName: json['consultationPackageName'],
    consultationPackagePrice: json['consultationPackagePrice']?.toDouble(),
    consultationPackageDescription: json['consultationPackageDescription'],
  );
}

  }

