import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/controller/current_user_controller.dart';
import 'package:house_to_motive/controller/get_video_controller.dart';
import 'package:house_to_motive/controller/search_user_controller.dart';
import 'package:house_to_motive/views/screens/profile_screen.dart';
import 'package:house_to_motive/views/screens/user_profile_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import '../../controller/event_controller.dart';
import '../../utils/utils.dart';

class VideoScreen extends StatefulWidget {
  // final videoUrl;
  const VideoScreen(
      {super.key,
        // this.videoUrl,
        required this.videoUrls,
        required this.initialIndex,
        required this.videoUserIdList,
        required this.title,
        this.userId,
        this.thumbnail,
        required this.videoIdList});
  final List<String> videoUrls;
  final List<String> videoUserIdList;
  final List<String> videoIdList;

  final int initialIndex;
  final String title;
  final String? userId;
  final String? thumbnail;
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FirestoreService firestoreService = Get.put(FirestoreService());
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('videos');
  final GetVideoController getVideoController = Get.put(GetVideoController());
  final videoLikecontroller = Get.put(VideoController());
  late final DocumentSnapshot videoDoc;
  final SearchUserController searchUserController =
  Get.put(SearchUserController());
  final CollectionReference videosCollection =
  FirebaseFirestore.instance.collection('videos');
  late CurrentUserController currentUserController;
  @override
  void initState() {
    super.initState();
    // searchUserController.getApplicationUsers();
    currentUserController = Get.put(CurrentUserController(context: context));
    currentUserController.getCurrentUser();
    firestoreService.getCurrentUser();
  }

  Future<Map<String, dynamic>?> fetchUserData(int index) async {
    try {
      var userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.videoUserIdList[index])
          .get();
      return userDocument.data();
    } catch (e) {
      log("Error fetching user data: $e");
      return null;
    }
  }

  late VideoPlayerController videoController; // Track the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: videosCollection.snapshots(),
                builder: (context, snapshot) {
                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // No connection state
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(child: Text('No connection'));
                  }

                  // Error state
                  if (snapshot.hasError) {
                    // Error details will be shown to help in debugging
                    return Center(
                        child:
                        Text('Error fetching videos: ${snapshot.error}'));
                  }

                  // No data state
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No videos found'));
                  }

                  List<DocumentSnapshot> videoDocs = snapshot.data!.docs;

                  return PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.videoUrls.length,
                    controller:
                    PageController(initialPage: widget.initialIndex),
                    onPageChanged: (index) {
                      log('Current video index: $index');
                    },
                    itemBuilder: (context, index) {
                      String? location;
                      String? priceRange;
                      String? description;
                      String? userName;
                      String? userId;
                      DocumentSnapshot videoDoc = videoDocs[index];
                      String videoId = videoDoc.id;

                      // Extract video data from the videoDocs list
                      for (var doc in videoDocs) {
                        if (doc.id == widget.videoIdList[index]) {
                          location = doc.get('location') ?? "";
                          priceRange = doc.get('priceRange') ?? "";
                          description = doc.get('description') ?? "";
                          userName = doc.get('userName') ?? "";
                          userId = doc.get('userId') ?? "";
                          break;
                        }
                      }

                      videoLikecontroller.checkInitialLikeStatus(videoId);

                      return Stack(
                        children: [
                          // Video Player
                          VideoPlayerScreen(
                            videoUrl: widget.videoUrls[index],
                            onControllerCreated: (controller) {
                              videoController = controller;
                            },
                            userId: widget.videoUserIdList[index],
                          ),

                          Positioned(
                            bottom: 13.h,
                            left: .5.h,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.h, vertical: .9.h),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50.px),
                                            color: const Color(0xff000000)
                                                .withOpacity(0.1)),
                                        child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              // SvgPicture.asset(
                                              //   'assets/svgs/locationnew.svg',
                                              //   height: 2.h,
                                              // ),
                                              const SizedBox(width: 20),
                                              Text(
                                               location!.length< 30
                                                   ? location
                                                   : '${location.substring(0, 15)}...',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              )

                                            ]),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        description!,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Starting Price: £$priceRange',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      SizedBox(
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 3.7.h,
                            left: 2.h,
                            right: 2.h,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 1.6.h),
                              decoration: BoxDecoration(
                                color: const Color(0xff000000).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(2.h),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Like Button and Count
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                            () => InkWell(
                                          onTap: () {
                                            if (widget.title == 'latest' || widget.title == 'near') {
                                              videoLikecontroller.toggleLikeDislike(videoId);
                                              videoLikecontroller.checkInitialLikeStatus(videoId);
                                            } else {
                                              videoLikecontroller.toggleLikeDislike(videoDoc.id);
                                            }
                                          },
                                          child: videoLikecontroller.userLiked.value
                                              ? SvgPicture.asset('assets/svgs/Like icon red.svg', height: 3.2.h)
                                              : SvgPicture.asset('assets/svgs/emptylike.svg', height: 3.2.h),
                                        ),
                                      ),
                                      SizedBox(height: .5.h),
                                      Obx(
                                            () => Text(
                                          videoLikecontroller.likesCount.toString(),
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Comments Button and Count
                                  Column(
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('comments')
                                            .where('videoId', isEqualTo: videoId)
                                            .snapshots(),
                                        builder: (context, commentsSnapshot) {
                                          // Check for errors in the comments snapshot
                                          if (commentsSnapshot.hasError) {
                                            return const Text('Error loading comments');
                                          }

                                          // Check if commentsSnapshot has data
                                          if (!commentsSnapshot.hasData || commentsSnapshot.data == null) {
                                            return const Text('Loading comments...');
                                          }

                                          // Initialize comment count
                                          int totalComments = 0;

                                          // Loop through each document to count comments
                                          for (var doc in commentsSnapshot.data!.docs) {
                                            final data = doc.data() as Map<String, dynamic>?; // Use commentsSnapshot instead of snapshot
                                            List<dynamic> comments = data?['comments'] ?? [];
                                            totalComments += comments.length;
                                          }

                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  videoController.pause();
                                                  await openBottomSheet(
                                                    context,
                                                    videoId,
                                                    userName: currentUserController.currentUserName.value,
                                                    profilePicUrl: currentUserController.currentUserProfile.value,
                                                    currentUserId: currentUserController.currentUserId.value,
                                                  );
                                                },
                                                child: SvgPicture.asset('assets/svgs/comment1.svg'),
                                              ),
                                              SizedBox(height: .5.h),
                                              Text(
                                                '$totalComments', // Added 'comments' for clarity
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),

                                    ],
                                  ),

                                  // Share Button
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Share.share("House To Motive ${widget.videoUrls[index]}");

                                          // firestoreService.fetchFollowersData(firestoreService.followers);
                                        },
                                        child: SvgPicture.asset('assets/svgs/sahre1.svg'),
                                      ),
                                      SizedBox(height: .6.h),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 28.7.h,
                            left: 1.h,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    videoController.pause();
                                    await Get.to(() => UserProfileScreen(
                                      userId: userId ?? "",
                                      userName: userName ?? "",
                                      profilePic: profilePicUrl ?? '',
                                    ));
                                    videoController.play();
                                  },
                                  child: FutureBuilder(
                                    future: fetchUserData(index),
                                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey.shade100,
                                          child: const CircleAvatar(radius: 20, backgroundColor: Colors.white),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else if (snapshot.hasData) {
                                        profilePicUrl = snapshot.data?['profilePic'];
                                        return CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.black,
                                          backgroundImage: NetworkImage(profilePicUrl!.isNotEmpty
                                              ? profilePicUrl!
                                              : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                                        );
                                      } else {
                                        return const Text("No user data available");
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: .9.h),
                                Text(
                                  userName??"",
                                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                Obx(
                                      () => GestureDetector(
                                    onTap: () async {
                                      bool updatedFollowStatus = await ticketController.toggleFollowUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userId??"",
                                      );
                                      getVideoController.isFollowing.value = updatedFollowStatus;
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: .3.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xffFFFFFF).withOpacity(0.25), width: 1),
                                        borderRadius: BorderRadius.circular(8.px),
                                      ),
                                      child: Text(
                                        getVideoController.isFollowing.value ? "Unfollow" : "Follow",
                                        style: const TextStyle(
                                          fontFamily: 'ProximaNova',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),


                        ],
                      );
                    },
                  );
                },
              )),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              padding: EdgeInsets.only(left: 8),
              onPressed: () {
              Get.back();
            }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,), style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black)
            ),),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String userId;
  final Function(VideoPlayerController) onControllerCreated;
  const VideoPlayerScreen(
      {super.key, required this.videoUrl, required this.userId, required this.onControllerCreated});

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      widget.onControllerCreated(_controller);
      _controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xff025B8F)));
        }
      },
    );
  }
}

class VideoController extends GetxController {
  var likesCount = 0.obs;
  var userLiked = false.obs;
  Future<void> toggleLikeDislike(String videoId) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;
    var userDocRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);
    var videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        var videoSnapshot = await transaction.get(videoRef);
        var userSnapshot = await transaction.get(userDocRef);

        if (!videoSnapshot.exists) {
          log('Video does not exist');
          return;
        }

        List<dynamic> likes = videoSnapshot.data()?['likes'] ?? [];
        List<dynamic> userLikedVideos =
            userSnapshot.data()?['likedVideos'] ?? [];

        bool isLiked = likes.contains(user.email);
        bool isInUserLikedVideos = userLikedVideos.contains(videoId);

        if (isLiked) {
          likes.remove(user.email);
        } else {
          likes.add(user.email);
        }

        if (isInUserLikedVideos) {
          userLikedVideos.remove(videoId);
        } else {
          userLikedVideos.add(videoId);
        }

        transaction.update(videoRef, {'likes': likes});
        transaction.update(userDocRef, {'likedVideos': userLikedVideos});

        log('Transaction successful: Updated likes and likedVideos');
      });
    } catch (e) {
      log('Transaction failed: $e');
    }
  }

  Future<void> checkInitialLikeStatus(String videoId) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    var videoRef = FirebaseFirestore.instance.collection('videos').doc(videoId);

    try {
      var videoSnapshot = await videoRef.get();
      if (!videoSnapshot.exists) return;

      List<dynamic> likes = videoSnapshot.data()?['likes'] ?? [];
      userLiked.value = likes.contains(user.email);
      likesCount.value = likes.length;
    } catch (e) {
      log('Error checking initial like status: $e');
    }
  }
}

void showCommentOptionsDialog(BuildContext context, String commentUserId, String commentUserName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Comment Options"),
      content: const Text("What would you like to do?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showBlockConfirmationDialog(context, commentUserId, commentUserName);
          },
          child: const Text("Block User"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showReportOptions(context, commentUserId, commentUserName);
          },
          child: const Text("Report User"),
        ),
      ],
    ),
  );
}

void showReportOptions(BuildContext context, String reportedUserId, String reportedUserName) {
  List<String> reportReasons = [
    "It's spam",
    "Hate speech or symbols",
    "Bullying or harassment",
    "False information",
    "Scam or fraud",
    "Violence or threats",
    "Other"
  ];

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Why are you reporting this comment?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...reportReasons.map((reason) => ListTile(
                  title: Text(reason),
                  onTap: () => showReportConfirmationDialog(context, reportedUserId, reportedUserName, reason),
                )),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void showReportConfirmationDialog(BuildContext context, String reportedUserId, String reportedUserName, String reason) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Report Comment"),
      content: Text("Are you sure you want to report $reportedUserName for \"$reason\"?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            Navigator.pop(context); // Close the bottom sheet
            submitReport(reportedUserId, reportedUserName, reason);
          },
          child: const Text("Report", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

void submitReport(String reportedUserId, String reportedUserName, String reason) async {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance.collection("reports").add({
    "reportedBy": currentUserId,
    "reportedUser": reportedUserId,
    "reportedUserName": reportedUserName,
    "reason": reason,
    "timestamp": FieldValue.serverTimestamp(),
  });

  Utils().ToastMessage('Your report has been submitted. Thank you for helping us keep the community safe.');
}

void showBlockConfirmationDialog(BuildContext context, String commentUserId, String commentUserName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Block User"),
      content: Text("Are you sure you want to block $commentUserName? You will no longer see their comments."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await blockUser(commentUserId);
            Navigator.pop(context);
          },
          child: const Text("Block"),
        ),
      ],
    ),
  );
}

Future<void> blockUser(String commentUserId) async {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot userSnapshot = await transaction.get(userDocRef);

    // Check if 'blockedUsers' field exists; if not, initialize it
    if (!userSnapshot.exists || !userSnapshot.data().toString().contains('blockedUsers')) {
      transaction.set(userDocRef, {'blockedUsers': []}, SetOptions(merge: true));
    }

    // Now safely update the blocked users list
    transaction.update(userDocRef, {
      'blockedUsers': FieldValue.arrayUnion([commentUserId])
    });
  });
}

Future<void> openBottomSheet(
    BuildContext context,
    String videoDocId, {
      required String userName,
      required String profilePicUrl,
      required String currentUserId,
    }) async {
  final TextEditingController commentController = TextEditingController();
  final CollectionReference commentsCollection = FirebaseFirestore.instance.collection('comments');

  Get.bottomSheet(
    SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasError || !userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Extract blocked users
              Map<String, dynamic>? userData = userSnapshot.data?.data() as Map<String, dynamic>?;
              List<String> blockedUsers = userData?['blockedUsers'] != null
                  ? List<String>.from(userData!['blockedUsers'])
                  : [];

              return StreamBuilder<DocumentSnapshot>(
                stream: commentsCollection.doc(videoDocId).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error loading comments");
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "No comments",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  List<dynamic> comments = data?['comments'] ?? [];

                  // Filter out comments from blocked users
                  List<dynamic> filteredComments = comments.where((comment) {
                    return !blockedUsers.contains(comment['userId']);
                  }).toList();

                  return filteredComments.isEmpty
                      ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "No comments",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                      : SizedBox(
                    height: 30.h,
                    child: ListView.builder(
                      itemCount: filteredComments.length,
                      itemBuilder: (context, index) {
                        var comment = filteredComments[index] as Map<String, dynamic>;
                        final String commentUserName = comment['userName'] ?? 'Unknown User';
                        final String text = comment['text'] ?? 'No text';
                        final String profilePic = comment['profilePic']?.isNotEmpty == true
                            ? comment['profilePic']
                            : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";

                        return GestureDetector(
                          onLongPress: () => showCommentOptionsDialog(context, comment['userId'], commentUserName),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 2.h),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black,
                                  backgroundImage: NetworkImage(profilePic, scale: 1.0),
                                ),
                                SizedBox(width: 2.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        commentUserName,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff151923),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        text,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff151923),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(
                    profilePicUrl.isNotEmpty
                        ? profilePicUrl
                        : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                  ),
                ),
                SizedBox(width: 2.h),
                Expanded(
                  child: SizedBox(
                    height: 4.h,
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: "Add comment",
                        isDense: true,
                        contentPadding: EdgeInsets.all(1.h),
                        hintStyle: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff8A8B8F),
                        ),
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                        fillColor: const Color(0xffF1F1F3),
                        filled: true,
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (commentController.text.isNotEmpty) {
                              await commentsCollection.doc(videoDocId).set({
                                'videoId': videoDocId,
                                'comments': FieldValue.arrayUnion([
                                  {
                                    'userName': userName,
                                    'profilePic': profilePicUrl,
                                    'userId': currentUserId,
                                    'text': commentController.text,
                                  }
                                ])
                              }, SetOptions(merge: true));
                              commentController.clear(); // Clear the input field
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
    ),
  );
}

// Future<void> openBottomSheet(
//     BuildContext context,
//     String videoDocId, {
//       required String userName,
//       required String profilePicUrl,
//       required String currentUserId,
//     }) async {
//   final TextEditingController commentController = TextEditingController();
//   final CollectionReference commentsCollection = FirebaseFirestore.instance.collection('comments');
//
//   Get.bottomSheet(
//     SingleChildScrollView(
//       child: Column(
//         children: [
//           StreamBuilder<QuerySnapshot>(
//             stream: commentsCollection.where('videoId', isEqualTo: videoDocId).snapshots(),
//             builder: (context, snapshot) {
//               // Check for errors
//               if (snapshot.hasError) {
//                 return const Text('Error loading comments');
//               }
//
//               // Check if snapshot has data
//               if (!snapshot.hasData || snapshot.data == null) {
//                 return const Text('Loading comments...');
//               }
//
//               // Initialize comment count
//               int totalComments = 0;
//
//               // Loop through each document to count comments in each
//               for (var doc in snapshot.data!.docs) {
//                 final data = doc.data() as Map<String, dynamic>?;
//                 List<dynamic> comments = data?['comments'] ?? [];
//                 totalComments += comments.length;
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       totalComments.toString(),
//                       style: GoogleFonts.inter(
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xff151923),
//                         fontSize: 13.04,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: const Icon(Icons.close, color: Colors.black, size: 16),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           StreamBuilder<DocumentSnapshot>(
//             stream: commentsCollection.doc(videoDocId).snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return const Text("Error loading comments");
//               }
//               if (!snapshot.hasData) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               // Check if document exists and contains comments
//               if (!snapshot.data!.exists) {
//                 return const Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 20),
//                     child: Text(
//                       "No comments",
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ),
//                 );
//               }
//
//               final data = snapshot.data!.data() as Map<String, dynamic>?;
//               List<dynamic> comments = data?['comments'] ?? [];
//
//               if (comments.isEmpty) {
//                 return const Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 20),
//                     child: Text(
//                       "No comments",
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ),
//                 );
//               }
//
//               return SizedBox(
//                 height: 30.h,
//                 child: ListView.builder(
//                   itemCount: comments.length,
//                   itemBuilder: (context, index) {
//                     var comment = comments[index] as Map<String, dynamic>;
//                     final String commentUserName = comment['userName'] ?? 'Unknown User';
//                     final String text = comment['text'] ?? 'No text';
//                     final String profilePic = comment['profilePic']?.isNotEmpty == true
//                         ? comment['profilePic']
//                         : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
//
//                     return GestureDetector(
//                       onTap: (){},
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 1.h),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SizedBox(width: 2.h),
//                             CircleAvatar(
//                               radius: 20,
//                               backgroundColor: Colors.black,
//                               backgroundImage: NetworkImage(profilePic,scale: 1.0),
//                             ),
//                             SizedBox(width: 2.h),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     commentUserName,
//                                     style: GoogleFonts.inter(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       color: const Color(0xff151923),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     text,
//                                     style: GoogleFonts.inter(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       color: const Color(0xff151923),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Colors.black,
//                   backgroundImage: NetworkImage(
//                     profilePicUrl.isNotEmpty
//                         ? profilePicUrl
//                         : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
//                   ),
//                 ),
//
//                 SizedBox(width: 2.h),
//                 Expanded(
//                   child: SizedBox(
//                     height: 4.h,
//                     child: TextField(
//                       controller: commentController,
//                       decoration: InputDecoration(
//                         hintText: "Add comment",
//                         isDense: true,
//                         contentPadding: EdgeInsets.all(1.h),
//                         hintStyle: GoogleFonts.inter(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xff8A8B8F),
//                         ),
//                         border: const OutlineInputBorder(borderSide: BorderSide.none),
//                         fillColor: const Color(0xffF1F1F3),
//                         filled: true,
//                         suffixIcon: IconButton(
//                           onPressed: () async {
//                             if (commentController.text.isNotEmpty) {
//                               await commentsCollection.doc(videoDocId).set({
//                                 'videoId': videoDocId,
//                                 'comments': FieldValue.arrayUnion([
//                                   {
//                                     'userName': userName,
//                                     'profilePic': profilePicUrl,
//                                     'userId': currentUserId,
//                                     'text': commentController.text,
//                                   }
//                                 ])
//                               }, SetOptions(merge: true));
//                               commentController.clear(); // Clear the input field
//                             }
//                           },
//                           icon: const Icon(Icons.send),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//     backgroundColor: Colors.white,
//     elevation: 0,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topRight: Radius.circular(20),
//         topLeft: Radius.circular(20),
//       ),
//     ),
//   );
// }
