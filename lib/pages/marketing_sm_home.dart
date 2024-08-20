import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/pages/advisor_list_screen.dart';
import 'package:vervevista/pages/top_appbar.dart';
import 'rating_screen.dart'; // Import the RatingScreen class

class MarketingSMHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: TopAppBar(
        title: 'Advisors',
        onLogout: () {
          _showLogoutConfirmationDialog(context);
        },
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255), // Background color of the interface
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // First vertical line
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdvisorListScreen()),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset('assets/images/marketplace.png', width: 70, height: 70),
                          const SizedBox(height: 8), // Space between image and text
                          const Text('Marketplace', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),

                  ],
                ),
                // Second vertical line
                Column(
                  children: [
                    const SizedBox(height: 20), // Space between pairs
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RatingScreen()), // Navigate to RatingScreen
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset('assets/images/rating.png', width: 70, height: 70),
                          const SizedBox(height: 8), // Space between image and text
                          const Text('Rating', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                // Third vertical line
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset('assets/images/logo.png', width: 70, height: 70),
            ),
          ],
        ),
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
