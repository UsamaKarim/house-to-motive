import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/controller/get_video_controller.dart';
import 'package:house_to_motive/views/screens/video_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/event_controller.dart';

import '../Favourites/newFav.dart';
import 'chatRoom.dart';
import 'notification_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePic,
  });
  final String userId;
  final String userName;
  final String profilePic;
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

TicketController ticketController = Get.put(TicketController());

class _UserProfileScreenState extends State<UserProfileScreen> {
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  final GetVideoController getVideoController = Get.put(GetVideoController());

  @override
  void initState() {
    super.initState();
    getVideoController.getUserVideos(widget.userId);
    ticketController.fetchFollowingList(widget.userId);
    ticketController.fetchFollowersList(widget.userId);
    getVideoController.checkFollowingStatus(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff025B8F),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 19,
          ),
        ),
        title: Text(
          widget.userName,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => FavList());
            },
            child: SvgPicture.asset('assets/appbar/heart.svg'),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Get.to(() => const NotificationScreen());
            },
            child: SvgPicture.asset('assets/appbar/Notification.svg'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              SizedBox(height: 10.px),
              Container(
                height: Get.height / 6,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              widget.profilePic.isNotEmpty
                                  ? widget.profilePic
                                  : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                              scale: 1.0,
                            ),
                            backgroundColor: Colors.black,
                          ),
                          Text(
                            (widget.userName.length) < 8
                                ? widget.userName
                                : '${widget.userName.substring(0, 6)}...',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          // Text(
                          //   'UI UX Designer',
                          //   style: GoogleFonts.inter(
                          //     color: const Color(0xff7390A1),
                          //     fontSize: 8,
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(width: 30.px),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 50.px,
                                // width: 50.px,
                                // color: Colors.black,
                                child: Column(
                                  children: [
                                    Text(
                                      'Followers',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff7390A1),
                                      ),
                                    ),
                                    Text(
                                      '${ticketController.followersList.length}',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff025B8F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 35.px),
                              SizedBox(
                                height: 50.px,
                                // width: 50.px,
                                // color: Colors.black,
                                child: Column(
                                  children: [
                                    Text(
                                      'Followings',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff7390A1),
                                      ),
                                    ),
                                    Text(
                                      '${ticketController.followingList.length}',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff025B8F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 35.px),
                              SizedBox(
                                height: 50.px,
                                // width: 50.px,
                                // color: Colors.black,
                                child: Column(
                                  children: [
                                    Text(
                                      'Posts',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff7390A1),
                                      ),
                                    ),
                                    Text(
                                      '${getVideoController.userVideos.length}',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff025B8F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          widget.userId ==
                                  FirebaseAuth.instance.currentUser?.uid
                              ? const SizedBox.shrink()
                              : Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => ChatPage(
                                          name: widget.userName,
                                          receiverEmail: widget.userId,
                                          receiverId: widget.userId,
                                          chatRoomId: chatRoomId(
                                            widget.userId,
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          ),
                                          pic: widget.profilePic,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xff025B8F),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          20.px,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Chat',
                                          style: TextStyle(
                                            fontFamily: 'ProximaNova',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff025B8F),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.px),
                                  GestureDetector(
                                    onTap: () async {
                                      bool updatedFollowStatus =
                                          await ticketController
                                              .toggleFollowUser(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                                widget.userId,
                                              );

                                      getVideoController.isFollowing.value =
                                          updatedFollowStatus;
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xff025B8F),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          20.px,
                                        ),
                                      ),
                                      child: Obx(
                                        () => Center(
                                          child: Text(
                                            getVideoController.isFollowing.value
                                                ? "Unfollow"
                                                : "Follow",
                                            style: const TextStyle(
                                              fontFamily: 'ProximaNova',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff025B8F),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.px),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: getVideoController.userVideos.length,
                  itemBuilder: (context, index) {
                    final videoData = getVideoController.userVideos[index];
                    final String thumbnailUrl = videoData['thumbnailUrl'] ?? '';
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => VideoScreen(
                            videoUrls: getVideoController.videoUrlList,
                            initialIndex: index,
                            videoUserIdList: getVideoController.videoUserIdList,
                            title: 'title',
                            videoIdList: getVideoController.videoIdList,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 20.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(thumbnailUrl, scale: 1.0),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
