import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/views/screens/ArcadeScreen.dart';
import 'package:house_to_motive/views/screens/user_profile_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'newFav.dart';

class FavEvents extends StatelessWidget {
  FavEvents({super.key});

  final FavListController controller = Get.put(FavListController());

  // @override
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                future:
                    FirebaseFirestore.instance
                        .collection('tickets')
                        .where('isEventFavourite', isEqualTo: true)
                        .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<DocumentSnapshot> docs = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = docs[index];
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
                        String organizerProfilePic =
                            data['userProfilePic'] ?? "";
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                                  'assets/svgs/home/map-pin.svg',
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  location.length > 30
                                                      ? '${location.substring(0, 30)}..'
                                                      : location,
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(
                                                      0xff7390A1,
                                                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        child: Obx(
                                          () => CircleAvatar(
                                            backgroundColor: const Color(
                                              0xff80ffff,
                                            ),
                                            radius: 16,
                                            child: Icon(
                                              size: 2.5.h,
                                              isFavorite.value
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
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
          ],
        ),
      ),
    );
  }
}
