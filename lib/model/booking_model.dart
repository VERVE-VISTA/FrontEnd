import 'package:flutter/foundation.dart';

class Booking {
  final String userId;
  final String advisorId;
  final DateTime bookingDate;
  final String communicationMethod;
  final String paymentStatus;
  final DateTime createdAt;

  Booking({
    required this.userId,
    required this.advisorId,
    required this.bookingDate,
    required this.communicationMethod,
    required this.paymentStatus,
    required this.createdAt,
  });

  // Factory constructor to create a Booking instance from a JSON object
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      userId: json['userId'],
      advisorId: json['advisorId'],
      bookingDate: DateTime.parse(json['bookingDate']),
      communicationMethod: json['communicationMethod'],
      paymentStatus: json['paymentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Method to convert a Booking instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'advisorId': advisorId,
      'bookingDate': bookingDate.toIso8601String(),
      'communicationMethod': communicationMethod,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
