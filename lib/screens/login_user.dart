import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'user_page.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: Scaffold(
        body: Container(
          color: const Color(0xFFFFB606),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Image.asset(
                          'assets/logo.png', // Replace with your image asset path
                          height: 150.0,
                          width: 150.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              'Sans Serif', // Replace with your desired font
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .white, // Set label text color to white
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: _passwordController,
                                style: const TextStyle(color: Colors.white),
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors
                                        .white, // Set label text color to white
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    loginUser(context);
                                  }
                                },
                                child: const Text('Login'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginUser(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Retrieve the user data from Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Check the role of the user
      String role = userData.get('role');
      if (role == 'admin') {
        // Navigate to the admin screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => adminPage()),
        );
      } else {
        // Navigate to the user screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => userDashboard()),
        );
      }
    } catch (e) {
      print('Failed to log in. Error: $e');
    }
  }
}
