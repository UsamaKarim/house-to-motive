import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../views/screens/video_screen.dart';

class FavVideos extends StatelessWidget {
  final String? userId;
  const FavVideos({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show shimmer effect while waiting for data
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: 10, // Number of shimmer items
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  );
                },
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User document does not exist'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          if (!userData.containsKey('likedVideos')) {
            return const Center(child: Text('No favorite videos'));
          }

          var likedVideos = userData['likedVideos'] as List<dynamic>;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: likedVideos.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('videos')
                        .doc(likedVideos[index])
                        .get(),
                builder: (context, videoSnapshot) {
                  if (videoSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      !videoSnapshot.hasData ||
                      !videoSnapshot.data!.exists) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  var videoData =
                      videoSnapshot.data!.data() as Map<String, dynamic>;

                  if (!videoData.containsKey('thumbnailUrl')) {
                    return const SizedBox(); // Return an empty SizedBox if thumbnailUrl field is missing
                  }
                  return GestureDetector(
                    onTap: () async {
                      List<String> videoUrls = [];
                      List<String> userIdsList2 = [];
                      List<String> thumbnailList = [];
                      List<String> videoIdList = [];

                      // Fetch video URLs and user IDs for all liked videos
                      for (var likedVideo in likedVideos) {
                        var videoSnapshot =
                            await FirebaseFirestore.instance
                                .collection('videos')
                                .doc(likedVideo)
                                .get();
                        if (videoSnapshot.exists) {
                          var videoData =
                              videoSnapshot.data() as Map<String, dynamic>;
                          if (videoData.containsKey('videoUrl')) {
                            videoUrls.add(videoData['videoUrl']);
                            userIdsList2.add(videoData['userId']);
                            thumbnailList.add(videoData["thumbnailUrl"]);
                            videoIdList.add(
                              videoSnapshot.id,
                            ); // Store the document ID
                            log("Document ID: ${videoSnapshot.id}");
                          }
                        }
                      }
                      Get.to(
                        () => VideoScreen(
                          videoUrls: videoUrls,
                          initialIndex: index,
                          videoUserIdList: userIdsList2,
                          title: 'title',
                          videoIdList: videoIdList, // Pass the video ID list
                          thumbnail:
                              thumbnailList[index], // Pass the corresponding thumbnail
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: NetworkImage(videoData["thumbnailUrl"]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            'assets/assets2/Video_images/platbtn.png',
                            height: 2.5.h,
                            width: 2.5.h,
                          ),
                        ),
                      ],
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
}

// GridView.builder(
// gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 3,
// crossAxisSpacing: 2,
// mainAxisSpacing: 2,
// childAspectRatio: 0.8,
// ),
// itemCount: VideoIMg.length,
// itemBuilder: (context, index) {
// return Stack(
// children: [
// Container(
// height: 200,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(5),
// image: DecorationImage(
// image: AssetImage(VideoIMg[index]),
// fit: BoxFit.fill)),
// ),
// Center(
// child: Image.asset(
// 'assets/assets2/Video_images/platbtn.png',
// height: 2.5.h,
// width: 2.5.h,
// ),
// )
// ],
// );
// }),
