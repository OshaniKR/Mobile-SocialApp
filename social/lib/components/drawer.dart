import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback? onHomeTap;
  final VoidCallback? onPostsTap;
  final VoidCallback? onMyPostsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onSignOut;

  const MyDrawer({
    super.key,
    this.onHomeTap,
    this.onPostsTap,
    this.onMyPostsTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.onSignOut,
  });

  // Fetch user data from Firestore
  Future<Map<String, String>> fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.email)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data()!;
      return {
        'profileImage': userData['profileImage'] ?? '', // Profile Image URL
        'username': userData['name'] ?? 'No Name', // User Name
      };
    } else {
      return {
        'profileImage': '', // Default values if no user data found
        'username': 'No Name',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFCF9A0E), // Match the yellow color
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top section: Profile and navigation items
          Column(
            children: [
              // Profile header with dynamic data
              FutureBuilder<Map<String, String>>(
                future: fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const DrawerHeader(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const DrawerHeader(
                      child: Center(
                        child: Text(
                          'Error loading profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    final userData = snapshot.data!;
                    return DrawerHeader(
                      child: Column(
                        children: [
                          // Profile picture
                          CircleAvatar(
                            radius: 40, // Circular image
                            backgroundImage: userData['profileImage'] != ''
                                ? NetworkImage(userData['profileImage']!)
                                : null,
                            child: userData['profileImage'] == ''
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 10), // Spacing
                          Text(
                            userData['username']!, // User name
                            style: const TextStyle(
                              color: Colors.white, // Match white color
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),

              // Navigation items
              _buildDrawerItem(
                icon: Icons.home,
                text: 'Home',
                onTap: onHomeTap,
              ),
              _buildDrawerItem(
                icon: Icons.photo_library,
                text: 'My Posts',
                onTap: () {
                  if (onMyPostsTap != null) {
                    onMyPostsTap!();
                  } else {
                    Navigator.pushNamed(
                        context, '/myPosts'); // Ensure correct navigation
                  }
                },
              ),
              _buildDrawerItem(
                icon: Icons.person,
                text: 'Profile',
                onTap: () {
                  if (onProfileTap != null) {
                    onProfileTap!();
                  } else {
                    Navigator.pushNamed(
                        context, '/profile'); // Correct navigation route
                  }
                },
              ),
              _buildDrawerItem(
                icon: Icons.settings,
                text: 'Settings',
                onTap: onSettingsTap,
              ),
            ],
          ),

          // Bottom section: Sign Out
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: _buildDrawerItem(
              icon: Icons.logout,
              text: 'Sign Out',
              onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
