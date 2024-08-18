import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vervevista/providers/user_provider.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  // Map to store the selected rating and comment for each advisor
  Map<String, int> selectedRatings = {};
  Map<String, TextEditingController> commentControllers = {};

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchAdvisors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Advisors'),
        backgroundColor: Colors.purple,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (userProvider.errorMessage?.isNotEmpty ?? false) {
            return Center(child: Text('Error: ${userProvider.errorMessage}'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: userProvider.advisors.length,
            itemBuilder: (context, index) {
              final advisor = userProvider.advisors[index];
              final imageUrl = advisor.profilePicture != null
                  ? 'http://10.0.2.2:3000/api/image/${advisor.profilePicture!.replaceFirst('uploads/', '')}'
                  : 'assets/images/girl.png';

              // Initialize controllers and ratings for each advisor if not already initialized
              if (!selectedRatings.containsKey(advisor.id)) {
                selectedRatings[advisor.id] = 0;
                commentControllers[advisor.id] = TextEditingController();
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.purple.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                advisor.name ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                advisor.specialization ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (starIndex) {
                          return IconButton(
                            icon: Icon(
                              Icons.star,
                              color: starIndex < selectedRatings[advisor.id]!
                                  ? Colors.yellow
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedRatings[advisor.id] = starIndex + 1;
                              });
                            },
                          );
                        }),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: commentControllers[advisor.id],
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedRatings[advisor.id]! > 0) {
                            userProvider.addRating(
                              advisorId: advisor.id,
                              rating: selectedRatings[advisor.id]!,
                              comment: commentControllers[advisor.id]!.text,
                            );
                            // Clear the input after submission
                            setState(() {
                              selectedRatings[advisor.id] = 0;
                              commentControllers[advisor.id]!.clear();
                            });
                          } else {
                            // Show an error message if rating is not selected
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select a rating.'),
                              ),
                            );
                          }
                        },
                        child: Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Image.asset('assets/images/report_b.png'),
                          onPressed: () {
                            // Handle report logic here
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
