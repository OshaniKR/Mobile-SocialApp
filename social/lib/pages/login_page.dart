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
    try {
      showLoadingDialog();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordTextController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
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
                      icon:
                          const Icon(Icons.arrow_forward, color: Colors.white),
                      label: const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
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
