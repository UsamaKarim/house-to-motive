import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final String? userId =
      FirebaseAuth.instance.currentUser?.uid; // Replace with actual user ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('videos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No videos found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot videoDoc = snapshot.data!.docs[index];
              return FutureBuilder<DocumentSnapshot<Object?>>(
                future: checkIfUserLikedVideo(videoDoc.id),
                builder: (context, likeSnapshot) {
                  bool isLiked = likeSnapshot.data?.exists ?? false;
                  return ListTile(
                    title: Text(videoDoc['location']),
                    subtitle: Text('Likes: ${videoDoc['likesCount']}'),
                    trailing: IconButton(
                      icon:
                          isLiked
                              ? SvgPicture.asset(
                                'assets/svgs/Like icon.svg',
                                color: Colors.red,
                              )
                              : SvgPicture.asset('assets/svgs/Unlike icon.svg'),
                      onPressed: () => toggleLike(videoDoc.id, isLiked),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> checkIfUserLikedVideo(String videoId) {
    return FirebaseFirestore.instance
        .collection('userLikes')
        .doc('${userId ?? 'anonymous'}_$videoId')
        .get();
  }

  void toggleLike(String videoId, bool isLiked) {
    final DocumentReference videoRef = FirebaseFirestore.instance
        .collection('videos')
        .doc(videoId);
    final DocumentReference likeRef = FirebaseFirestore.instance
        .collection('userLikes')
        .doc('${userId ?? 'anonymous'}_$videoId');

    FirebaseFirestore.instance
        .runTransaction((transaction) async {
          if (isLiked) {
            transaction.delete(likeRef);
            transaction.update(videoRef, {
              'likesCount': FieldValue.increment(-1),
            });
          } else {
            transaction.set(likeRef, {
              'userId': userId ?? 'anonymous',
              'videoId': videoId,
            });
            transaction.update(videoRef, {
              'likesCount': FieldValue.increment(1),
            });
          }
        })
        .then((_) {
          setState(() {}); // Refresh UI
        });
  }
}
