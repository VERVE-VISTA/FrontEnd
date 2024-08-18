import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/model/user_model.dart';
import 'package:vervevista/pages/top_appbar.dart';
import 'package:vervevista/providers/user_provider.dart'; // Ensure to import UserProvider

class ReportingScreen extends StatefulWidget {
  final String advisorId; // Pass the advisor ID to this screen

  ReportingScreen({required this.advisorId});

  @override
  _ReportingScreenState createState() => _ReportingScreenState();
}

class _ReportingScreenState extends State<ReportingScreen> {
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.reportAdvisor(
        advisorId: widget.advisorId,
        description: _descriptionController.text,
      );

      if (userProvider.errorMessage != null) {
        setState(() {
          _errorMessage = userProvider.errorMessage;
        });
      } else {
        // Report submitted successfully, navigate back or show success message
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
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
      appBar: TopAppBar(
        title: 'Reporting Screen',
        onLogout: () {
          _showLogoutConfirmationDialog(context);
        },
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Find the advisor by ID
          final advisor = userProvider.advisors.firstWhere(
            (advisor) => advisor.id == widget.advisorId,
            orElse: () => User(
              id: widget.advisorId,
              username: 'Unknown',
              password: '', // Use appropriate default value
              role: 'Unknown', // Use appropriate default value
              name: 'Unknown',
              profilePicture: null,
              specialization: 'Unknown',
            ),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Info
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          advisor.profilePicture != null
                              ? 'http://10.0.2.2:3000/api/image/${advisor.profilePicture?.replaceFirst('uploads/', '') ?? 'default.png'}'
                              : 'assets/images/default.png',
                        ),
                        radius: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        advisor.name??'',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(advisor.specialization??''
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Provide details about the issue with the advisor:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    errorText: _errorMessage,
                  ),
                ),
                SizedBox(height: 16),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitReport,
                        child: Text('Submit Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 245, 154, 229), // Adjust to match your theme
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
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
