import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/pages/home_page.dart';
import 'package:social/components/text_box.dart'; // Import the MyTextBox component

class SignInPage extends StatefulWidget {
  final Function()? onTap;

  const SignInPage({super.key, required this.onTap});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? message;
  String? sectionName;
  bool isError = false;

  // Show a loading dialog
  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Display a message in the text box
  void displayMessage(String msg, String section, bool error) {
    setState(() {
      message = msg;
      sectionName = section;
      isError = error;
    });
  }

  // SignIn method to handle login
  Future<void> signIn() async {
    if (emailTextController.text.isEmpty ||
        passwordTextController.text.isEmpty) {
      displayMessage('Please fill in all fields', 'Validation Error', true);
      return;
    }

    try {
      showLoadingDialog();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context); // Close the loading dialog
        displayMessage('Sign-in successful!', 'Success', false);
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the loading dialog
      displayMessage(e.message ?? 'An unknown error occurred', 'Error', true);
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog
      displayMessage('An unknown error occurred', 'Error', true);
    }
  }

  // Placeholder for editField function
  void editField(String field) {
    // Implement your edit logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.orange.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/petpals.png', // Update with the correct path
                      height: 150,
                      width: 150,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email TextField
                  TextField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password TextField
                  TextField(
                    controller: passwordTextController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  if (message != null && sectionName != null)
                    MyTextBox(
                      text: message!,
                      sectionName: sectionName!,
                      onPressed: () => editField('bio'),
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: signIn, // Use the signIn method here

                      label: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18, // Increase the text size
                          fontWeight:
                              FontWeight.bold, // Make the text bold (optional)
                          color: Colors.white, // Set the text color to white
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.orange.shade800, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60, // Increase the button width
                          vertical: 15, // Increase the button height
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      )
                    ],
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
