import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("Users");
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> editField(String field, String currentValue) async {
    String newValue = currentValue;
    TextEditingController textController =
        TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orange.shade800,
        title: Text("Edit $field", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          onChanged: (value) => newValue = value,
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
                userCollection.doc(currentUser.email).update({field: newValue});
                Navigator.of(context).pop();
              }
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> uploadImage(String imageType) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imagePath =
            'user_profiles/${currentUser.email}/$imageType/${pickedFile.name}';

        // Read the file as bytes for web compatibility
        final bytes = await pickedFile.readAsBytes();

        // Upload the file to Firebase Storage
        final uploadTask = storageRef.child(imagePath).putData(bytes);

        // Wait for upload to complete
        await uploadTask;

        // Get the download URL of the uploaded image
        String imageUrl = await storageRef.child(imagePath).getDownloadURL();

        // Update the Firestore document with the image URL
        await userCollection
            .doc(currentUser.email)
            .update({imageType: imageUrl});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${imageType} uploaded successfully.')),
        );
      }
    } catch (e) {
      print("Error uploading $imageType: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error uploading $imageType. Please try again.')),
      );
    }
  }

  Future<String> getImageUrl(String path) async {
    try {
      String downloadUrl = await storageRef.child(path).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error getting image URL: $e");
      return '';
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
              padding: EdgeInsets.symmetric(vertical: 20),
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
                SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      Text(userData['name'] ?? 'No Name',
                          style: TextStyle(
                              fontSize: 20, color: Colors.orange.shade800)),
                      Text(userData['email'] ?? 'No Email',
                          style: TextStyle(
                              fontSize: 16, color: Colors.orange.shade800)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text('My Details',
                      style: TextStyle(color: Colors.orange.shade800)),
                ),
                MyTextBox(
                  text: userData['name'] ?? 'No Name',
                  sectionName: "Name",
                  onPressed: () => editField('name', userData['name'] ?? ''),
                ),
                MyTextBox(
                  text: userData['homeTown'] ?? 'No hometown',
                  sectionName: "Home Town",
                  onPressed: () =>
                      editField('homeTown', userData['homeTown'] ?? ''),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    onPressed: () => uploadImage('profileImage'),
                    child: Text("Upload Profile Image"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    onPressed: () => uploadImage('petImage'),
                    child: Text("Upload Pet's Image"),
                  ),
                ),
                SizedBox(height: 20),
                if (userData['petImage'] != null)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text('My Pet\'s Image',
                            style: TextStyle(color: Colors.orange.shade800)),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder<String>(
                        future: getImageUrl(userData['petImage']),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (imageSnapshot.hasError) {
                            return Icon(Icons.error,
                                color: Colors.orange.shade800);
                          } else if (imageSnapshot.hasData) {
                            return Image.network(
                              imageSnapshot.data!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Icon(Icons.error,
                                color: Colors.orange.shade800);
                          }
                        },
                      ),
                    ],
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
  final VoidCallback onPressed;

  const MyTextBox({
    required this.text,
    required this.sectionName,
    required this.onPressed,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 246, 210, 155),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child:
                  Text(text, style: TextStyle(color: Colors.orange.shade800)),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange.shade800),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
