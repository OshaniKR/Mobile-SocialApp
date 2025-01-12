import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("Users");
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> uploadImage(String imageType) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imagePath =
            'user_profiles/${currentUser.email}/$imageType/${pickedFile.name}';
        final bytes = await pickedFile.readAsBytes();
        final uploadTask = storageRef.child(imagePath).putData(bytes);

        await uploadTask;
        String imageUrl = await storageRef.child(imagePath).getDownloadURL();
        await userCollection
            .doc(currentUser.email)
            .update({imageType: imageUrl});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$imageType uploaded successfully.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error uploading $imageType. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text("Profile Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userCollection.doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>?;

            if (userData == null) {
              return Center(child: Text('No data found.'));
            }

            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userData['profileImage'] != null
                          ? NetworkImage(userData['profileImage'])
                          : null,
                      child: userData['profileImage'] == null
                          ? Icon(Icons.person,
                              size: 50, color: Colors.orange.shade800)
                          : null,
                    ),
                    IconButton(
                      onPressed: () => uploadImage('profileImage'),
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      color: Colors.orange.shade800,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                MyTextBox(
                  text: userData['name'] ?? 'No Name',
                  sectionName: "Name",
                ),
                MyTextBox(
                  text: userData['email'] ?? 'No Email',
                  sectionName: "Email",
                ),
                MyTextBox(
                  text: userData['homeTown'] ?? 'No Hometown',
                  sectionName: "Home Town",
                ),
                MyTextBox(
                  text: userData['petName'] ?? 'No Pet Name',
                  sectionName: "Pet Name",
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => uploadImage('petImage'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text("Upload Pet's Image"),
                ),
                if (userData['petImage'] != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pet's Image",
                          style: TextStyle(
                              fontSize: 16, color: Colors.orange.shade800),
                        ),
                        SizedBox(height: 10),
                        Image.network(
                          userData['petImage'],
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;

  const MyTextBox({
    required this.text,
    required this.sectionName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            "$sectionName:",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.orange.shade800),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
