import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart'; // Add DevicePreview
import 'package:social/auth/login_or_register.dart'; // Your login page
import 'firebase_options.dart';
import 'pages/my_posts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: true, // Enable DevicePreview
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true, // Required for DevicePreview
      locale:
          DevicePreview.locale(context), // Use the locale from DevicePreview
      builder: DevicePreview.appBuilder, // Integrate DevicePreview
      home: const SplashScreen(), // Start with SplashScreen
      routes: {
        '/login': (context) => const LoginOrRegister(),
        '/myPosts': (context) => MyPostsPage(), // Define your login route
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to login page after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.orange.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Foreground Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the paw image
                Image.asset(
                  'assets/petpals.png', // Path to your asset image
                  width: 160,
                  height: 160,
                ),
                const SizedBox(height: 20),
                // Display "PetPals" text
                const Text(
                  "PetPals",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCF9A0E), // Gold color for text
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
