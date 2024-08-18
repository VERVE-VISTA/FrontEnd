import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vervevista/pages/payment_screen.dart';
import 'package:vervevista/pages/top_appbar.dart';
import 'package:vervevista/providers/user_provider.dart';

class BookAdvisorScreen extends StatefulWidget {
  final String advisorId;

  BookAdvisorScreen({required this.advisorId});

  @override
  _BookAdvisorScreenState createState() => _BookAdvisorScreenState();
}

class _BookAdvisorScreenState extends State<BookAdvisorScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedCommunicationMethod = '';

  @override
  void initState() {
    super.initState();
    // Fetch advisor data by ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchAdvisorById(widget.advisorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.userId;
    final advisor = userProvider.advisor;

    return Scaffold(
      appBar: TopAppBar(
        title: 'Booking Screen',
        onLogout: () {
          _showLogoutConfirmationDialog(context);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Info (Static for Now)
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'http://10.0.2.2:3000/api/image/${advisor?.profilePicture?.replaceFirst('uploads/', '') ?? 'default.png'}',
                    ), // replace with actual image URL
                    radius: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${advisor?.name ?? 'No Name'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('${advisor?.specialization ?? 'No Specialization'}'),
                ],
              ),
            ),

            // Plan Information
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  advisor?.consultationPackageName ?? 'Unknown Package',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            // Calendar Widget
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDate,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),

            SizedBox(height: 20),

            // Communication Method Section
            Center(
              child: Column(
                children: [
                  Text(
                    'COMMUNICATION METHOD:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10.0, // Space between items horizontally
                    runSpacing: 10.0, // Space between items vertically
                    alignment: WrapAlignment.center,
                    children: [
                      _buildCommunicationIcon('call.png', 'Phone'),
                      _buildCommunicationIcon('chat.png', 'Chat'),
                      _buildCommunicationIcon('meet.png', 'Google Meet'),
                      _buildCommunicationIcon('zoom.png', 'Zoom'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Book Now Button
            Center(
              child: ElevatedButton(
onPressed: _selectedCommunicationMethod.isEmpty
    ? null
    : () async {
        try {
          final bookingId = await userProvider.bookAdvisor(
            userId: userId,
            advisorId: widget.advisorId,
            bookingDate: _selectedDate.toIso8601String(),
            communicationMethod: _selectedCommunicationMethod,
          );

          if (bookingId != null) {
            // Navigate to PaymentScreen and pass the bookingId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(bookingId: bookingId),
              ),
            );
          } else {
            // Handle the case where bookingId is null
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking failed. Please try again.')),
            );
          }
        } catch (e) {
          // Handle any errors during booking
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred: $e')),
          );
        }
      },


                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/booking.png', width: 24), // Replace with actual path
                    SizedBox(width: 8),
                    Text('BOOK NOW'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 206, 135, 218).withOpacity(0.3), // Adjust opacity
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Communication Icon
  Widget _buildCommunicationIcon(String assetName, String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCommunicationMethod = method;
        });
      },
      child: Column(
        children: [
          Image.asset('assets/images/$assetName', width: 55, height: 55),
          SizedBox(height: 5),
          Container(
            width: 60,
            height: 2,
            color: _selectedCommunicationMethod == method
                ? Colors.purple
                : Colors.transparent,
          ),
        ],
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
