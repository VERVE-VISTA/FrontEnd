import 'package:flutter/material.dart';
import 'package:vervevista/pages/advisor_list_screen.dart';
import 'rating_screen.dart'; // Import the RatingScreen class

class MarketingSMHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const SizedBox(height: 20), // Space between pairs
                    Image.asset('assets/images/chat.png', width: 70, height: 70),
                    const SizedBox(height: 8), // Space between image and text
                    const Text('Chatting', style: TextStyle(fontSize: 16)),
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
}
