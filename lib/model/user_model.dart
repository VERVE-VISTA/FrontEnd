import 'package:vervevista/model/review_model.dart';

class User {
  String id;
  String username;
  String password;
  String role;
  String? profilePicture;
  DateTime createdAt;

  String? name;
  String? specialization;
  double? hourlyRate;
  List<String>? availability;
  List<Review>? reviews;
  String? servicesOffered;
  String? consultationPackageName;
  double? consultationPackagePrice;
  String? consultationPackageDescription;
  double? averageRating;

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
    this.averageRating,
  }) : createdAt = createdAt ?? DateTime.now();

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
      averageRating: json['averageRating'] != null
          ? double.tryParse(json['averageRating'].toString()) ?? 0.0
          : 0.0,  // Default to 0.0 if null or invalid
    );
  }
}
