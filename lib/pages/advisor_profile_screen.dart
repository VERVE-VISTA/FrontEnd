import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/model/user_model.dart';
import 'package:vervevista/pages/booking_screen.dart';
import 'package:vervevista/pages/top_appbar.dart';
import 'package:vervevista/providers/user_provider.dart';

class AdvisorProfileScreen extends StatefulWidget {
  final String advisorId;

  AdvisorProfileScreen({required this.advisorId});

  @override
  _AdvisorProfileScreenState createState() => _AdvisorProfileScreenState();
}

class _AdvisorProfileScreenState extends State<AdvisorProfileScreen> {
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
    return Scaffold(
      appBar: TopAppBar(
        title: 'Advisor Details',
        onLogout: () {
          _showLogoutConfirmationDialog(context);
        },
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final advisor = userProvider.advisor;

          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (userProvider.errorMessage?.isNotEmpty ?? false) {
            return Center(child: Text('Error: ${userProvider.errorMessage}'));
          }

          if (advisor == null) {
            return Center(child: Text('No advisor data available'));
          }

          final imageUrl = advisor.profilePicture != null
              ? 'http://10.0.2.2:3000/api/image/${advisor.profilePicture!.replaceFirst('uploads/', '')}'
              : 'assets/images/girl.png';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
                color: Color(0xFFF5F5F5),
                child: _buildProfileCard(advisor, imageUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildInfoCard(
                          icon: AssetImage('assets/images/lampe.png'),
                          title: 'Package Name: ${advisor.consultationPackageName}',
                          subtitle: 'Package Price: ${advisor.consultationPackagePrice}\$', 
                          description: 'Package Description: ${advisor.consultationPackageDescription ?? ''}',
                        ),
                        SizedBox(height: 16.0),
                        _buildInfoCard(
                          icon: AssetImage('assets/images/time.png'),
                          title: 'Hourly Charge: ${advisor.hourlyRate}\$/H',
                          subtitle: 'Offered Services: ${advisor.servicesOffered}' ?? '',
                          description: 'Availability: ${_buildAvailabilityString(advisor.availability)}',
                        ),
                        SizedBox(height: 20.0),
                        // Add booking button
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the booking screen and pass the advisorId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookAdvisorScreen(advisorId: widget.advisorId),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today, color: Colors.white),
                              SizedBox(width: 8.0),
                              Text(
                                'Book Now',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 245, 154, 229), // Green background color
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(User advisor, String imageUrl) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color(0x4CD835FB),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    advisor.name ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    advisor.specialization ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '${advisor.hourlyRate}/H',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: _buildRatingStars(advisor.averageRating),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.0),
            Image.asset('assets/images/logo.png', height: 50),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRatingStars(double? averageRating) {
    int fullStars = averageRating?.floor() ?? 0;
    bool hasHalfStar = averageRating != null && averageRating - fullStars >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return List<Widget>.generate(fullStars, (index) {
      return Icon(Icons.star, color: Colors.yellow, size: 24);
    })
      ..addAll(List<Widget>.generate(
        hasHalfStar ? 1 : 0,
        (index) => Icon(Icons.star_half, color: Colors.yellow, size: 24),
      ))
      ..addAll(List<Widget>.generate(
        emptyStars,
        (index) => Icon(Icons.star_border, color: Colors.yellow, size: 24),
      ));
  }

  Widget _buildInfoCard({
    ImageProvider? icon,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xD835FB).withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Image(image: icon, width: 40, height: 40),
          if (icon != null) SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildAvailabilityString(List<String>? availability) {
    if (availability == null || availability.isEmpty) return 'No availability information';
    return availability.join(', ').replaceAll(',', '\n');
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
