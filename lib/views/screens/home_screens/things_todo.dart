import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/controller/event_controller.dart';
import 'package:house_to_motive/controller/get_video_controller.dart';
import 'package:house_to_motive/controller/search_user_controller.dart';
import 'package:house_to_motive/views/screens/ArcadeScreen.dart';
import 'package:house_to_motive/views/screens/Sanzio_Restaurant.dart';
import 'package:house_to_motive/views/screens/custom_marker.dart';
import 'package:house_to_motive/views/screens/video_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import 'home_model.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> urls = [];

  final GetVideoController getVideoController = Get.put(GetVideoController());
  final SearchUserController searchUserController =
      Get.put(SearchUserController());

  // @override
  // void initState() {
  //   super.initState();
  //   getVideoController.checkNearbyVideos().then((value) {
  //     getVideoController.convertDistanceToKilometers();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  Future<void> loadVideos() async {
    await getVideoController.checkNearbyVideos();
    // getVideoController.convertDistanceToKilometers();
  }

  @override
  Widget build(BuildContext context) {
    final TicketController ticketController = Get.put(TicketController());

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Near Me',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              // InkWell(
              //     onTap: () {
              //       // Get.to(() => VideoScreen());
              //     },
              //     child: SvgPicture.asset(
              //         'assets/svgs/home/Group 1171274839.svg'),),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Obx(() => getVideoController.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Padding(
              padding: const EdgeInsets.only(left: 12),
              child: getVideoController.nearByVideos.isEmpty
                  ? const Center(
                      child: Text(
                        'No Locations Near Me',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : SizedBox(
                      height: screenHeight * 0.16,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: min(getVideoController.nearByVideos.length,
                            userDataList.length),
                        itemBuilder: (context, index) {
                          videoInfo video =
                              getVideoController.nearByVideos[index];
                          return GestureDetector(
                            onTap: () {
                              searchUserController
                                  .getApplicationUsers()
                                  .then((value) {
                                searchUserController.getCurrentUserData(
                                    getVideoController.videoUserIdsList[index]);
                              }).then((value) {
                                Get.to(() => VideoScreen(
                                      videoUrls: getVideoController
                                          .videoUrlsNearByLocation,
                                      initialIndex: index,
                                      videoUserIdList:
                                          getVideoController.videoUserIdsList,
                                      title: 'near',
                                      thumbnail: getVideoController
                                          .thumbnailList[index],
                                      userId: getVideoController
                                          .videoUserIdsList[index],
                                      videoIdList: getVideoController.idList,
                                    ));
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.2),
                                    backgroundImage:
                                        NetworkImage("${video.thumbnailUrl}"),
                                    maxRadius: 5.h,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    "${video.location.value.length <= 8 ? video.userName : '${video.location.value.substring(0, 8)}..'}",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    (getVideoController.kilometersList[index]
                                                    .toString())
                                                .length <
                                            5
                                        ? ('(${getVideoController
                                        .kilometersList[index]
                                        .toString()} km)')
                                        : '(${getVideoController.kilometersList[index].toString().substring(0, 3)} km)',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff7390A1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            )),
        SizedBox(height: screenHeight * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Videos',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              // InkWell(
              //     onTap: () {
              //       // Get.to(() => VideoScreen());
              //     },
              //     child: SvgPicture.asset(
              //         'assets/svgs/home/Group 1171274839.svg')),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Discover the best upcoming events',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff7390A1),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        SizedBox(
          height: 31.25.h,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('videos')
                  .where('timestamp',
                      isGreaterThanOrEqualTo: DateTime.now().toUtc().subtract(
                          const Duration(
                              days: 7))) // Filter videos from the last 24 hours
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show shimmer effect while waiting for data
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // Number of shimmer items
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 48.w,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  );
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  // Show text message if there are no videos
                  return const Center(
                    child: Text(
                      'No latest videos in the last 72 hours',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // If there are videos, display them
                RxList<String> videoThumbnailUrls = <String>[].obs;
                RxList<String> videoUrls = <String>[].obs;
                RxList<String> userIds = <String>[].obs;

                RxList<String> thumbnailsList = <String>[].obs;
                RxList<String> videoIdList = <String>[].obs;

                for (var doc in documents) {
                  videoIdList.add(doc.id);
                  videoThumbnailUrls.add(doc['thumbnailUrl']);
                  videoUrls.add(doc['videoUrl']);
                  userIds.add(doc['userId']);
                  thumbnailsList.add(doc['thumbnailUrl']);
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videoThumbnailUrls.length,
                  itemBuilder: (context, index) {
                    // Show actual data
                    return GestureDetector(
                      onTap: () {
                        searchUserController
                            .getApplicationUsers()
                            .then((value) {
                          searchUserController
                              .getCurrentUserData(userIds[index]);
                        }).then((value) {
                          Get.to(() => VideoScreen(
                                videoUrls: videoUrls,
                                initialIndex: index,
                                videoUserIdList: userIds,
                                title: 'latest',
                                userId: userIds[index],
                                thumbnail: thumbnailsList[index],
                                videoIdList: videoIdList,
                              ));
                        });
                        // Open VideoScreen with the selected video index
                      },
                      child: Container(
                        width: 48.w,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(videoThumbnailUrls[index]),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/assets2/Video_images/platbtn.png',
                              height: 22,
                              width: 22,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Videos',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              // InkWell(
              //   onTap: () {
              //     // Get.to(() => VideoScreen());
              //   },
              //   child:
              //       SvgPicture.asset('assets/svgs/home/Group 1171274839.svg'),
              // ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Discover the best upcoming events',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff7390A1),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        SizedBox(
          height: 25.37.h,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
            ),
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('videos').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show shimmer effect while waiting for data
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10, // Number of shimmer items
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 35.w,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  );
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final documents = snapshot.data!.docs;
                List<String> videoThumbnailUrls = [];
                List<String> videoUrls = [];
                List<String> userIdsList = [];
                List<String> idList = [];

                for (var doc in documents) {
                  idList.add(doc.id);
                  videoThumbnailUrls.add(doc['thumbnailUrl']);
                  videoUrls.add(doc['videoUrl']);
                  userIdsList.add(doc['userId']);
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videoThumbnailUrls.length,
                  itemBuilder: (context, index) {
                    // Show actual data
                    return GestureDetector(
                      onTap: () {
                        searchUserController
                            .getApplicationUsers()
                            .then((value) {
                          searchUserController
                              .getCurrentUserData(userIdsList[index]);
                        }).then((value) {
                          // Open VideoScreen with the selected video index
                          Get.to(() => VideoScreen(
                                videoUrls: videoUrls,
                                initialIndex: index,
                                videoUserIdList: userIdsList,
                                title: 'title',
                                userId: userIdsList[index],
                                videoIdList: idList,
                              ));
                        });
                      },
                      child: Container(
                        width: 35.w,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(videoThumbnailUrls[index]),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(),
                            Container(),
                            Image.asset(
                              'assets/assets2/Video_images/platbtn.png',
                              height: 22,
                              width: 22,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Food Near Me',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     // Get.to(() => VideoScreen());
              //   },
              //   child:
              //       SvgPicture.asset('assets/svgs/home/Group 1171274839.svg'),
              // ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Best match near me - watch and explore',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff7390A1),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        SizedBox(
            height: 26.h,
            // height: 250,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("restaurants")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Data Available'));
                }
                final data = snapshot.data!.docs;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final docData = data[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => SanzioRestaurant(
                              imageUrl: docData["imageUrl"],
                              location: docData["location"],
                              description: docData["description"],
                              closingTime: docData["closingTime"],
                              imageName: docData["imageName"],
                              openingTime: docData["openingTime"],
                              restaurantName: docData["restaurantName"],
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Stack(
                          children: [
                            Container(
                              height: screenHeight * 0.26,
                              width: Get.width / 1.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // SizedBox(height: 1.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          docData["restaurantName"]
                                                      .toString()
                                                      .length >
                                                  15
                                              ? "${docData["restaurantName"].toString().substring(0, 15)}..."
                                              : docData["restaurantName"],
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        // Text(
                                        //   '£${docData["location"]}',
                                        //   style: const TextStyle(
                                        //     fontSize: 14,
                                        //     fontWeight: FontWeight.w500,
                                        //     color: Color(0xff025B8F),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    SizedBox(height: 0.3.h),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   children: [
                                    //     GradientText(
                                    //       text: "${foodnearby[index].mile} mile",
                                    //       gradient: const LinearGradient(colors: [
                                    //         Color(0xffFF0092),
                                    //         Color(0xff216DFD),
                                    //       ]),
                                    //       style: GoogleFonts.inter(
                                    //         fontWeight: FontWeight.w400,
                                    //         fontSize: 10,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 0.3.h),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svgs/home/map-pin.svg'),
                                        SizedBox(width: 0.3.h),
                                        Text(
                                          docData["location"]
                                                      .toString()
                                                      .length >
                                                  15
                                              ? "${docData["location"].toString().substring(0, 15)}..."
                                              : docData["location"],
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff7390A1),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: Get.height / 6,
                              width: Get.width / 1.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    docData["imageUrl"],
                                  ),
                                ),
                                // color: Colors.white,
                              ),
                              // child: Padding(
                              //   padding: const EdgeInsets.all(12),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Container(
                              //         height: 3.5.h,
                              //         width: 8.h,
                              //         decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(20),
                              //             color: const Color(0xff80ffff),
                              //             border:
                              //             Border.all(color: Colors.white60)),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //           MainAxisAlignment.spaceEvenly,
                              //           children: [
                              //             SvgPicture.asset(
                              //                 'assets/svgs/home/Star 2.svg'),
                              //             Text(
                              //               foodnearby[index].rating,
                              //               style: GoogleFonts.inter(
                              //                   fontSize: 10,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: Colors.white),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       CircleAvatar(
                              //         backgroundColor: const Color(0xff80FFFF),
                              //         radius: 16,
                              //         child: SvgPicture.asset(
                              //             'assets/svgs/home/Vector.svg'),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )),
        SizedBox(height: screenHeight * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              // InkWell(
              //   onTap: () {
              //     // Get.to(() => VideoScreen());
              //   },
              //   child:
              //       SvgPicture.asset('assets/svgs/home/Group 1171274839.svg'),
              // ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Discover the best upcoming events',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff7390A1),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('tickets')
                .where('private', isEqualTo: false)
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // List<DocumentSnapshot> docs = snapshot.data!.docs;

                List<DocumentSnapshot> docs = snapshot.data!.docs;

                // **Filter upcoming events**
                List<DocumentSnapshot> upcomingEvents = docs.where((doc) {
                  Timestamp dateTimestamp = doc['date'] ?? Timestamp.now();
                  DateTime eventDate = dateTimestamp.toDate();
                  return eventDate.isAfter(DateTime.now()); // Only keep future events
                }).toList();

                if (upcomingEvents.isEmpty) {
                  return const Center(child: Text('No upcoming events available.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: upcomingEvents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = upcomingEvents[index];
                    Map<String, dynamic>? data =
                        doc.data() as Map<String, dynamic>?;

                    if (data == null || data.isEmpty) {
                      return Container();
                    }

                    String eventName = data['eventName'] ?? "";
                    String photoURL = data['photoURL'] ?? "";
                    String description = data['description'] ?? "";
                    String startTime = data['startTime'] ?? "";
                    String endTime = data['endTime'] ?? "";
                    String location = data['location'] ?? "";
                    String familyPrice = data['familyPrice'] ?? "";
                    String childPrice = data['childPrice'] ?? "";
                    String adultPrice = data['adultPrice'] ?? "";
                    Timestamp date = data['date'] ?? Timestamp.now();
                    String organizerName = data['userName'] ?? "";
                    String organizerProfilePic = data['userProfilePic'] ?? "";
                    bool isPrivate = data['private'] ?? false;
                    String ticketUid = data['uid'] ?? "";
                    String id = data['id'] ?? "";
                    bool isTicketFav = data['isEventFavourite'] ?? false;
                    bool isPaid = data['isPaid'] ?? false;

                    RxBool isFavorite = isTicketFav.obs;

                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ArcadeScreen(
                            description: description,
                            photoURL: photoURL,
                            startTime: startTime,
                            endTime: endTime,
                            eventName: eventName,
                            location: location,
                            date: date,
                            familyPrice: familyPrice,
                            adultPrice: adultPrice,
                            childPrice: childPrice,
                            oragnizerName: organizerName,
                            OrganizerProfilePic: organizerProfilePic,
                            ticketUid: ticketUid,
                            isPaid: isPaid,
                            isEventFavourite: isFavorite.value,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              height: screenHeight * 0.32,
                              width: screenWidth / 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eventName.length > 35
                                              ? '${eventName.substring(0, 35)}..'
                                              : eventName,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 0.3.h),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/svgs/home/map-pin.svg'),
                                            const SizedBox(width: 3),
                                            Text(
                                              location.length > 30
                                                  ? '${location.substring(0, 30)}..'
                                                  : location,
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff7390A1),
                                                fontSize: 10,
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
                          ),
                          Container(
                            height: screenHeight * 0.27,
                            width: Get.width / 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(photoURL),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      isFavorite.toggle();
                                      await ticketController
                                          .updateTicketCollection(
                                        id.obs,
                                        isFavorite.value.obs,
                                      );
                                    },
                                    child: Obx(() => CircleAvatar(
                                          backgroundColor:
                                              const Color(0xff80ffff),
                                          radius: 16,
                                          child: Icon(
                                            size: 2.5.h,
                                            isFavorite.value
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.red,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
      ],
    );
  }
}
