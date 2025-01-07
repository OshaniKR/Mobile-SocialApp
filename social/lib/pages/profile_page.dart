import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("Users");

  // Function to edit field
  Future<void> editField(String field, String currentValue) async {
    String newValue = currentValue;
    TextEditingController textController =
        TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orange.shade800, // Orange dialog background
        title: Text(
          "Edit $field",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: textController, // Set the controller
          autofocus: true,
          style: TextStyle(color: Colors.white), // White text color
          onChanged: (value) {
            newValue = value; // Update newValue as text changes
          },
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              if (newValue.trim().isNotEmpty) {
                // Update Firestore document only if the new value is not empty
                userCollection
                    .doc(currentUser
                        .email) // Or use currentUser.uid if preferred
                    .update({field: newValue});
                Navigator.of(context).pop();
              }
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Function to delete field
  Future<void> deleteField(String field) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orange.shade800, // Orange dialog background
        title: Text(
          "Delete $field",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to delete this $field?",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              // Remove the field from Firestore
              userCollection
                  .doc(currentUser.email) // Or use currentUser.uid if preferred
                  .update({field: FieldValue.delete()});
              Navigator.of(context).pop();
            },
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50], // Light orange background
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange, // Orange app bar background
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email) // Or use currentUser.uid if preferred
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            // Safely check if the data exists and cast it to Map<String, dynamic>
            final userData = snapshot.data!.data() as Map<String, dynamic>?;

            if (userData == null) {
              return const Center(child: Text('No data found.'));
            }

            return ListView(
              children: [
                const SizedBox(height: 50),

                // Profile pic
                const Icon(
                  Icons.person,
                  size: 72,
                  color: Colors.orange, // Orange color for the profile icon
                ),

                const SizedBox(height: 10),

                // User email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade800), // Orange color for email
                ),

                const SizedBox(height: 50),

                // User details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(
                        color: Colors.orange.shade800), // Orange text color
                  ),
                ),

                // Username
                MyTextBox(
                  text: userData['username'] ?? 'No username', // Add null check
                  sectionName: "Username",
                  onPressed: () =>
                      editField('username', userData['username'] ?? ''),
                  onDelete: () => deleteField('username'),
                ),
                const SizedBox(height: 10),

                // Birthday
                MyTextBox(
                  text: userData['birthday'] ?? 'No birthday', // Add null check
                  sectionName: "Birthday",
                  onPressed: () =>
                      editField('birthday', userData['birthday'] ?? ''),
                  onDelete: () => deleteField('birthday'),
                ),

                const SizedBox(height: 10),

                MyTextBox(
                  text: userData['homeTown'] ?? 'No hometown', // Add null check
                  sectionName: "HomeTown",
                  onPressed: () =>
                      editField('homeTown', userData['homeTown'] ?? ''),
                  onDelete: () => deleteField('homeTown'),
                ),

                const SizedBox(height: 10),

                MyTextBox(
                  text: userData['petName'] ?? 'No pet', // Add null check
                  sectionName: "PetName",
                  onPressed: () =>
                      editField('petName', userData['petName'] ?? ''),
                  onDelete: () => deleteField('petName'),
                ),

                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Posts',
                    style: TextStyle(
                        color: Colors.orange.shade800), // Orange text color
                  ),
                ),

                // Posts section
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Posts")
                      .where("userEmail",
                          isEqualTo:
                              currentUser.email) // Filter by the user's email
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.hasData) {
                      final posts = snapshot.data!.docs;

                      return Column(
                        children: [
                          // Display posts
                          for (var post in posts)
                            ListTile(
                              title: Text(post[
                                  'content']), // Assuming posts have a 'content' field
                              subtitle: Text(
                                  'Posted on: ${post['timestamp'].toDate()}'), // Assuming posts have a timestamp
                              tileColor: Colors.orange[100],
                            ),
                        ],
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  const MyTextBox({
    required this.text,
    required this.sectionName,
    required this.onPressed,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 246, 210, 155), // Change to orange color
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.orange.shade800), // Orange text color
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange.shade800),
              onPressed: onPressed,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.orange.shade800),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
