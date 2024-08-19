// lib/models/chat_message.dart
import 'package:flutter/foundation.dart';

class ChatMessage {
  final String sender;
  final String receiver;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'],
      receiver: json['receiver'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
