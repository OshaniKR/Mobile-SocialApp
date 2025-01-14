import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/wall_post.dart';

class MyPostsPage extends StatefulWidget {
  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade800,
          title: const Text('My Posts'),
        ),
        body: const Center(child: Text('User not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: const Text('My Posts'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("User Posts")
              .where("UserEmail", isEqualTo: currentUser?.email)
              .orderBy("TimeStamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data!.docs[index];
                  return WallPost(
                    message: post['Message'],
                    user: post['UserEmail'] ?? 'Anonymous',
                    postId: post.id,
                    time: (post['TimeStamp'] as Timestamp).toDate().toString(),
                    likes: List<String>.from(post['Likes'] ?? []),
                  );
                },
              );
            } else {
              return const Center(child: Text('No posts yet'));
            }
          },
        ),
      ),
    );
  }
}
