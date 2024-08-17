import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/pages/custom_bottom_navigation_bar.dart';
import 'package:vervevista/pages/marketing_sm_home.dart';
import 'package:vervevista/pages/second_container.dart';
import 'package:vervevista/pages/simple_container.dart';
import 'package:vervevista/pages/third_container.dart';
import 'package:vervevista/pages/top_appbar.dart';
import 'package:vervevista/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateBasedOnUserRole();
    });
  }

  Future<void> _navigateBasedOnUserRole() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserProfileById(userProvider.userId);
    
    final role = userProvider.getUserRole();
    
    setState(() {
      if (role == 'User') {
        _currentIndex = 0; // Set initial index for user role
      } else if (role == 'Advisor') {
        _currentIndex = 0; // Set initial index for advisor role (adjust as needed)
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/role');
  }

  void _showLogoutConfirmationDialog() {
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
                _logout();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  final List<Widget> _userPages = [
    MarketingSMHome(), // User's home page
    SecondContainer(),
  ];

  final List<Widget> _advisorPages = [
    SimpleContainer(),
    ThirdContainer()
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final role = userProvider.getUserRole();

    return Scaffold(
      appBar: TopAppBar(
        title: 'Home',
        onLogout: _showLogoutConfirmationDialog,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: role == 'User' ? _userPages : _advisorPages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
