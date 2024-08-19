import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/pages/top_appbar.dart';
import 'package:vervevista/providers/user_provider.dart'; // Import your UserProvider

class ChatScreen extends StatefulWidget {
  final String advisorId; // Pass the advisor ID to this screen

  const ChatScreen({Key? key, required this.advisorId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late UserProvider _userProvider;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = []; // Ensure _messages is a List<Map<String, dynamic>>
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProvider = context.read<UserProvider>(); // Initialize _userProvider
      _fetchMessages(); // Fetch messages after initialization
    });
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    try {
      // Fetch messages
      await _userProvider.fetchMessagesBetweenUserAndAdvisor(
        userId: _userProvider.userId,
        advisorId: widget.advisorId,
      );
      setState(() {
        _messages = _userProvider.messages.cast<Map<String, dynamic>>(); // Ensure correct type
        _isLoading = false; // Hide loading indicator
      });
    } catch (e) {
      // Handle errors
      print('Error fetching messages: $e');
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await _userProvider.sendMessageFromUserToAdvisor(
        senderId: _userProvider.userId,
        receiverId: widget.advisorId,
        message: _messageController.text.trim(),
      );
      _messageController.clear();
      _fetchMessages(); // Refresh messages after sending
    } catch (e) {
      // Handle errors
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: 'Advisor Details',
        onLogout: () {
          _showLogoutConfirmationDialog(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUserMessage = message['senderRole'] == 'User';

                      return Align(
                        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isUserMessage ? Colors.purple : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['senderName'] ?? 'Unknown', // Handle null senderName
                                      style: TextStyle(
                                        color: isUserMessage ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      message['message'] ?? '', // Handle null message
                                      style: TextStyle(
                                        color: isUserMessage ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _formatTimestamp(message['timestamp'] ?? '1970-01-01T00:00:00Z'), // Handle null timestamp
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.purple, // Send button color
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'Invalid date'; // Handle parsing errors
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/role');
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
