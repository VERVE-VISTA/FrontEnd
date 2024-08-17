import 'package:intl/intl.dart';

class Review {
  String advisorId;  // Refers to the advisor (who is also a user)
  String userId;     // Refers to the user writing the review
  int rating;        // Rating should be between 1 and 5
  String comment;    // Comment is required
  DateTime createdAt;  // The date the review was created

  Review({
    required this.advisorId,
    required this.userId,
    required this.rating,
    required this.comment,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructor to create a Review from a JSON object
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      advisorId: json['advisorId'],
      userId: json['userId'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Method to convert Review to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'advisorId': advisorId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
