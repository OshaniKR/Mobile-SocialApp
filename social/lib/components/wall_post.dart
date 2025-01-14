import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/components/comment_button.dart';
import 'package:social/components/like_button.dart';
import 'package:social/components/comment.dart';
import 'package:social/components/helper/helper_methods.dart';
import 'package:social/components/delete_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;
  final String? imageUrl;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
    this.imageUrl,
  }) : super(key: key);

  @override
  _WallPostState createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late bool isLiked;
  final _commentTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;

  // Firestore collection constants
  static const userPostsCollection = "User Posts";
  static const commentsCollection = "Comments";

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    _uploadedImageUrl = widget.imageUrl;
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }

  // Handle image picking
  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        await uploadImage(File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Handle image upload
  Future<void> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'post_images/${widget.postId}/${DateTime.now().toIso8601String()}');
      final uploadTask = await storageRef.putFile(image);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection(userPostsCollection)
          .doc(widget.postId)
          .update({'imageUrl': imageUrl});

      setState(() {
        _uploadedImageUrl = imageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  // Toggle like state
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    final postRef = FirebaseFirestore.instance
        .collection(userPostsCollection)
        .doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // Add a comment to Firestore
  void addComment(String commentText) async {
    try {
      if (commentText.trim().isEmpty) return;

      await FirebaseFirestore.instance
          .collection(userPostsCollection)
          .doc(widget.postId)
          .collection(commentsCollection)
          .add({
        "CommentText": commentText,
        "CommentBy": currentUser.email,
        "CommentTime": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e')),
      );
    }
  }

  // Show a dialog for adding comments
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              _commentTextController.clear();
              Navigator.pop(context);
            },
            child: const Text("Post"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Delete the post and its comments
  Future<void> deletePost() async {
    try {
      final commentDocs = await FirebaseFirestore.instance
          .collection(userPostsCollection)
          .doc(widget.postId)
          .collection(commentsCollection)
          .get();

      for (var doc in commentDocs.docs) {
        await doc.reference.delete();
      }

      await FirebaseFirestore.instance
          .collection(userPostsCollection)
          .doc(widget.postId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.user == currentUser.email) DeleteButton(onTap: deletePost),
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC7BCAD), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(widget.message, style: const TextStyle(fontSize: 16)),
                if (_uploadedImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _uploadedImageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(widget.time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              LikeButton(isLiked: isLiked, onTap: toggleLike),
              const SizedBox(width: 10),
              CommentButton(onTap: showCommentDialog),
              const Spacer(),
              if (widget.user == currentUser.email)
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text("Upload Image"),
                ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(userPostsCollection)
                .doc(widget.postId)
                .collection(commentsCollection)
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentBy"],
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
