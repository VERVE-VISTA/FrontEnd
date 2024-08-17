import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vervevista/providers/user_provider.dart';
import 'package:vervevista/pages/top_appbar.dart'; // Import TopAppBar

class AdvisorListScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: 'Advisors',
        onLogout: () {
          _showLogoutConfirmationDialog(context);
        },
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (userProvider.errorMessage.isNotEmpty) {
                  return Center(child: Text('Error: ${userProvider.errorMessage}'));
                }

                return GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: userProvider.advisors.length,
                  itemBuilder: (context, index) {
                    final advisor = userProvider.advisors[index];
                    final imageUrl = advisor.profilePicture != null
                        ? 'http://10.0.2.2:3000/api/image/${advisor.profilePicture!.replaceFirst('uploads/', '')}'
                        : 'assets/images/girl.png';

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Colors.purple.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: advisor.profilePicture != null
                                  ? NetworkImage(imageUrl)
                                  : AssetImage('assets/images/girl.png') as ImageProvider,
                            ),
                            SizedBox(height: 8),
                            Text(
                              advisor.specialization ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              advisor.name ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                return Icon(
                                  i <
                                          (advisor.reviews?.map((e) => e.rating).reduce((a, b) => a + b) ?? 0) /
                                          (advisor.reviews?.length ?? 1)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.yellow,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserProvider>().fetchAdvisors();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3), // Background color with 30% opacity
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset('assets/images/search.png'),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Image.asset('assets/images/tri.png'),
              onPressed: () {
                // Trigger sorting by rating descending
                context.read<UserProvider>().fetchAdvisorsSortedByRatingDesc();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Trigger search by keyword
                final keyword = _searchController.text.trim();
                if (keyword.isNotEmpty) {
                  context.read<UserProvider>().searchAdvisors(keyword);
                }
              },
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
