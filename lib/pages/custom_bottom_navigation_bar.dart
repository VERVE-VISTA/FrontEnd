import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vervevista/pages/marketing_sm_home.dart'; // Update with correct import path
import 'package:vervevista/pages/second_container.dart';
import 'package:vervevista/pages/simple_container.dart';
import 'package:vervevista/pages/third_container.dart';
import 'package:vervevista/providers/user_provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final role = userProvider.getUserRole();

    List<BottomNavigationBarItem> items = [];
    List<Widget> pages = [];

    if (role == 'User') {
      items = [
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/marketplace.png', width: 24, height: 24),
          label: 'Marketplace',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Star',
        ),
      ];

      pages = [
        MarketingSMHome(),
        SecondContainer(),
      ];
    } else if (role == 'Advisor') {
      items = [
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Advisors',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Star',
        ),
      ];

      pages = [
        SimpleContainer(),
        ThirdContainer(),
      ];
    } else {
      // Default case to handle unexpected roles or empty roles
      items = [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];

      pages = [
        MarketingSMHome(), // Use any default page
        SecondContainer(),
      ];
    }

    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF4A4C52).withOpacity(0.8),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: items,
    );
  }
}


