import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vervevista/providers/user_provider.dart'; // Import your UserProvider
import 'package:vervevista/pages/chat_screenA.dart'; // Import the ChatScreen

class UsersListScreen extends StatefulWidget {
  final String advisorId; // Pass the advisor ID to this screen

  const UsersListScreen({Key? key, required this.advisorId}) : super(key: key);

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late UserProvider _userProvider;
  bool _isLoading = false;
  bool _hasError = false; // To track if there's an error

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProvider = context.read<UserProvider>();
      if (widget.advisorId.isEmpty) {
        // If advisorId is empty, show an error message
        setState(() {
          _hasError = true;
        });
      } else {
        _fetchUsers();
      }
    });
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _userProvider.fetchSuccessfulPaymentsAndUsers(widget.advisorId);
    } catch (e) {
      print('Error fetching users: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch users: ${e.toString()}')),
      );
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: Center(
        child: _hasError
            ? Text(
                'No valid advisor ID provided or an error occurred.',
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              )
            : Consumer<UserProvider>(
                builder: (context, provider, child) {
                  final users = provider.successfulPaymentsAndUsers;
                  if (_isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (users == null || users.isEmpty) {
                    return Center(child: Text('No users available'));
                  } else {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(user['username'] ?? 'Unknown'),
                          subtitle: Text(user['communicationMethod'] ?? 'No method'),
                          trailing: IconButton(
                            icon: Icon(Icons.message),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreenA(userId: user['userId'] ?? ''),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
      ),
    );
  }
}
