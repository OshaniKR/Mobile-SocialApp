import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5), // Light background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Paw icons
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/petpals.png',
                  width: 80,
                  height: 80,
                )
              ],
            ),
            const SizedBox(height: 20),
            // PetPals text
            Text(
              "PetPals",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFCF9A0E), // Gold color for text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
