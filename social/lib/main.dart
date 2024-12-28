import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:social/auth/auth.dart';
import 'package:social/auth/login_or_register.dart';
import 'package:social/pages/get_started.dart';
import 'package:social/pages/home_page.dart';
import 'firebase_options.dart';
import 'package:social/themes/dark_theme.dart';
import 'package:social/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the correct options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: true,
      tools: const [
        ...DevicePreview.defaultTools,
        // CustomPlugin(), // Uncomment or remove this line if CustomPlugin() is defined
      ],
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
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthPage(), // This is the starting point of your app
      routes: {
        '/login': (context) => const LoginOrRegister(),
        '/getStarted': (context) => const GetStartedPage(),
        '/home': (context) => const HomePage(),
      },
      // Add DevicePreview configurations
      builder: DevicePreview.appBuilder,
    );
  }
}
