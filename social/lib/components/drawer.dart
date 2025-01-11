import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback? onHomeTap;
  final VoidCallback? onPostsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onSignOut;

  const MyDrawer({
    super.key,
    this.onHomeTap,
    this.onPostsTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:
          const Color(0xFFCF9A0E), // Match the yellow color from the image
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top section: Profile and navigation items
          Column(
            children: [
              // Profile header
              const DrawerHeader(
                child: Column(
                  children: [
                    // Profile picture
                    CircleAvatar(
                      radius: 40, // Circular image
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150'), // Replace with actual profile image URL
                    ),
                    SizedBox(height: 10), // Spacing
                    Text(
                      'Amal de Silva', // User name
                      style: TextStyle(
                        color: Colors.white, // Match white color from the image
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation items
              _buildDrawerItem(
                icon: Icons.home,
                text: 'Home',
                onTap: onHomeTap,
              ),
              _buildDrawerItem(
                icon: Icons.photo_library,
                text: 'Posts',
                onTap: onPostsTap,
              ),
              _buildDrawerItem(
                icon: Icons.person,
                text: 'Profile',
                onTap: onProfileTap,
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
