// registration.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String feedbackMessage = '';

  Future<void> registerUser() async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // Replace the server URL with your actual server address
    final String serverUrl = 'http://localhost/recipes/register.php';

    // Check if password and confirmPassword match
    if (password != confirmPassword) {
      setState(() {
        feedbackMessage = 'Error: Passwords do not match';
      });
      return;
    }

    // Prepare data to send to the server
    final Map<String, dynamic> data = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        body: data,
      );

      if (response.statusCode == 200) {
        setState(() {
          feedbackMessage = 'Registration successful';
          // Optionally, reset the text fields after successful registration
          firstNameController.clear();
          lastNameController.clear();
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
        });
        // Optionally, you can navigate to another screen on success
      } else {
        setState(() {
          feedbackMessage = 'Registration failed. Error: ${response.body}';
        });
        // Handle the error, show a message, etc.
      }
    } catch (error) {
      setState(() {
        feedbackMessage = 'Error: $error';
      });
      // Handle the error, show a message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // Change the color of the back button
        ),
        title: Row(
          children: [
            SizedBox(width: 8.0),
            Text(
              'Register',
              style: TextStyle(
                color: Colors.black, // Text color black
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFAFAFA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: registerUser,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Change the background color
                onPrimary: Colors.white, // Change the text color
              ),
              child: Text('Register'),
            ),
            SizedBox(height: 16.0),
            Text(
              feedbackMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
