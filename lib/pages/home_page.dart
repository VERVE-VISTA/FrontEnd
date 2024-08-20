import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/pages/custom_bottom_navigation_bar.dart';
import 'package:vervevista/pages/marketing_sm_home.dart';
import 'package:vervevista/pages/second_container.dart';
import 'package:vervevista/pages/simple_container.dart';
import 'package:vervevista/pages/third_container.dart';
import 'package:vervevista/pages/top_appbar.dart';
import 'package:vervevista/pages/user_list_screen.dart';
import 'package:vervevista/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      _navigateBasedOnUserRole();
    });
  }

  Future<void> _navigateBasedOnUserRole() async {
    await _userProvider.fetchUserProfileById(_userProvider.userId);

    final role = _userProvider.getUserRole();

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

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<UserProvider>(context).getUserRole();

    // Ensure that _userProvider is updated based on the context in build
    _userProvider = Provider.of<UserProvider>(context);

    final List<Widget> _userPages = [
      MarketingSMHome(), // User's home page
 
    ];

    final List<Widget> _advisorPages = [
      UsersListScreen(advisorId: _userProvider.advisorId ?? ""), // Handle potential null advisorId
    ];

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
