import 'package:intl/intl.dart';

class Payment {
  String bookingId;
  double amount;
  String paymentMethod; // Should be 'CreditCard'
  DateTime paymentDate;
  String status; // Should be either 'Success' or 'Failed'

  Payment({
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.status,
  });

  // Factory constructor to create a Payment object from a JSON object
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      bookingId: json['bookingId'],
      amount: json['amount'].toDouble(),
      paymentMethod: json['paymentMethod'],
      paymentDate: DateTime.parse(json['paymentDate']),
      status: json['status'],
    );
  }

  // Method to convert a Payment object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentDate': paymentDate.toIso8601String(),
      'status': status,
    };
  }
}
