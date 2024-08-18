import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for routing
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:http_parser/http_parser.dart';
import 'package:vervevista/providers/user_provider.dart'; // Update with your actual path

class AdvisorSignupPage extends StatefulWidget {
  @override
  _AdvisorSignupPageState createState() => _AdvisorSignupPageState();
}

class _AdvisorSignupPageState extends State<AdvisorSignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController servicesOfferedController = TextEditingController();
  final TextEditingController consultationPackageNameController = TextEditingController();
  final TextEditingController consultationPackagePriceController = TextEditingController();
  final TextEditingController consultationPackageDescriptionController = TextEditingController();

  bool _isLoading = false;
  String? _profilePicturePath; // Path to the selected profile picture
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicturePath = pickedFile.path;
      });
    }
  }

  Future<void> _registerAdvisor() async {
    final String username = usernameController.text;
    final String password = passwordController.text;
    final String name = nameController.text;
    final String specialization = specializationController.text;
    final double hourlyRate = double.tryParse(hourlyRateController.text) ?? 0.0;
    final List<String> availability = availabilityController.text.split(','); // Assuming comma-separated input
    final String? profilePicture = _profilePicturePath; // Use the picked image path if available
    final String? servicesOffered = servicesOfferedController.text.isEmpty ? null : servicesOfferedController.text;
    final String? consultationPackageName = consultationPackageNameController.text.isEmpty ? null : consultationPackageNameController.text;
    final double? consultationPackagePrice = double.tryParse(consultationPackagePriceController.text);
    final String? consultationPackageDescription = consultationPackageDescriptionController.text.isEmpty ? null : consultationPackageDescriptionController.text;

    if (username.isEmpty || password.isEmpty || name.isEmpty || specialization.isEmpty || hourlyRate <= 0.0 || availability.isEmpty) {
      // Show error or notify user about missing fields
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final uri = Uri.parse('http://10.0.2.2:3000/api/signupAd'); // Update with your API endpoint
      final request = http.MultipartRequest('POST', uri)
        ..fields['username'] = username
        ..fields['password'] = password
        ..fields['name'] = name
        ..fields['specialization'] = specialization
        ..fields['hourlyRate'] = hourlyRate.toString()
        ..fields['availability'] = availability.join(',')
        ..fields['servicesOffered'] = servicesOffered ?? ''
        ..fields['consultationPackageName'] = consultationPackageName ?? ''
        ..fields['consultationPackagePrice'] = consultationPackagePrice?.toString() ?? ''
        ..fields['consultationPackageDescription'] = consultationPackageDescription ?? '';

      if (profilePicture != null) {
        final file = await http.MultipartFile.fromPath(
          'profilePicture',
          profilePicture,
          contentType: MediaType('image', 'jpg'), // Adjust based on your image type
        );
        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        // Handle success
        Get.toNamed('/MarketingSMHome');
      } else {
        // Handle failure
        print('Failed to register advisor: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle error silently or log it for debugging
      print('Failed to register advisor: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Image.asset(
              'assets/images/top_circle.png',
              width: 200,
              height: 200,
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Image.asset(
              'assets/images/bottom_circle.png',
              width: 200,
              height: 200,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  const Text(
                    'Welcome Onboard!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD835FB),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/registerimage.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: _profilePicturePath == null
                                ? Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[600],
                                    size: 50,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.file(
                                      File(_profilePicturePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: specializationController,
                          decoration: InputDecoration(
                            hintText: 'Specialization',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: hourlyRateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Hourly Rate',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: availabilityController,
                          decoration: InputDecoration(
                            hintText: 'Availability (comma-separated)',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: servicesOfferedController,
                          decoration: InputDecoration(
                            hintText: 'Services Offered (optional)',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: consultationPackageNameController,
                          decoration: InputDecoration(
                            hintText: 'Consultation Package Name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: consultationPackagePriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Consultation Package Price',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: consultationPackageDescriptionController,
                          decoration: InputDecoration(
                            hintText: 'Consultation Package Description',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD835FB),
                            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: _isLoading ? null : _registerAdvisor,
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6D00B7)),
                                )
                              : Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            TextButton(
                              onPressed: () => Get.toNamed('/signinA'),
                              child: Text('Log In'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
