import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final Function()? onPressed;

  const MyTextBox({
    Key? key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section name
            Text(
              sectionName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8), // Space between section name and text

            // Row to align username text and settings icon
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Aligns items on the ends
              children: [
                Text(
                  text, // Display the actual text
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                IconButton(
                  onPressed: () {}, // You can implement the onPressed function
                  icon: Icon(
                    Icons.settings,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
