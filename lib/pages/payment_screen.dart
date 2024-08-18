import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/pages/top_appbar.dart';
import 'package:vervevista/providers/user_provider.dart';

class PaymentScreen extends StatelessWidget {
  final String bookingId;

  PaymentScreen({required this.bookingId});

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1C4FB),
      appBar: TopAppBar(
        title: 'Booking Screen',
        onLogout: () {
          _showLogoutConfirmationDialog(context);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            Image.asset('assets/images/card.png', height: 180),
            SizedBox(height: 20),
            _buildTextField(label: 'Card Number', controller: _cardNumberController),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(label: 'CVV', controller: _cvvController),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(label: 'Expiration Date', controller: _expiryDateController),
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                await userProvider.makePayment(
                  bookingId: bookingId,
                  amount: 100.0, // Example amount
                  cardNumber: _cardNumberController.text,
                );

                if (userProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(userProvider.errorMessage!)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment successful!')),
                  );
                }
              },
              child: Image.asset('assets/images/pay.png', height: 50),
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/visa.png', height: 50),
            SizedBox(height: 20),
            Image.asset('assets/images/bridgepayment.png', height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label :',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          style: TextStyle(color: Colors.black),
        ),
      ],
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
