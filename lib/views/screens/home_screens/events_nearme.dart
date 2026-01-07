import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/controller/event_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../ArcadeScreen.dart';
import '../custom_marker.dart';

class EventsNearmeScreen extends StatefulWidget {
  const EventsNearmeScreen({super.key});

  @override
  State<EventsNearmeScreen> createState() => _EventsNearmeScreenState();
}

class _EventsNearmeScreenState extends State<EventsNearmeScreen> {
  RxList<TicketInfo> nearbyNextEvents = <TicketInfo>[].obs;
  RxList<TicketInfo> nearbyPastEvents = <TicketInfo>[].obs;

  RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    checkNearbyTickets();
  }

  // Future<void> checkNearbyTickets() async {
  //   isLoading.value = true; // Start loading
  //   Position currentPosition = await _determinePosition();
  //
  //   FirebaseFirestore.instance
  //       .collection('tickets')
  //       .where('private', isEqualTo: false)
  //       .get()
  //       .then((querySnapshot) async {
  //     for (var ticket in querySnapshot.docs) {
  //       String ticketLocationAddress = ticket.get('location');
  //       List<Location> locations = await locationFromAddress(ticketLocationAddress);
  //
  //       if (locations.isNotEmpty) {
  //         Location ticketLocation = locations.first;
  //         double distance = Geolocator.distanceBetween(
  //           currentPosition.latitude,
  //           currentPosition.longitude,
  //           ticketLocation.latitude,
  //           ticketLocation.longitude,
  //         );
  //
  //         if (distance <= 1000) {
  //           DateTime eventDateTime = (ticket.get('date') as Timestamp).toDate();
  //
  //           TicketInfo ticketInfo = TicketInfo(
  //             id: ticket.id,
  //             eventName: ticket.get('eventName'),
  //             photoURL: ticket.get('photoURL'),
  //             location: ticket.get('location'),
  //             date: ticket.get('date'),
  //             familyPrice: ticket.get('familyPrice'),
  //             startTime: ticket.get('startTime'),
  //             endTime: ticket.get('endTime'),
  //             childPrice: ticket.get('childPrice'),
  //             adultPrice: ticket.get('adultPrice'),
  //             description: ticket.get('description'),
  //             organizarImage: ticket.get('userProfilePic'),
  //             isFollow: ticket.get('isEventFavourite'),
  //             organizarName: ticket.get('userName'),
  //             isPaid: ticket.get('isPaid'),
  //             ticketUid: ticket.get('uid'),
  //           );
  //
  //           if (eventDateTime.isBefore(DateTime.now())) {
  //             nearbyPastEvents.add(ticketInfo);
  //           } else {
  //             nearbyNextEvents.add(ticketInfo);
  //           }
  //         }
  //       }
  //     }
  //     isLoading.value = false; // Stop loading after fetching data
  //   }).catchError((error) {
  //     isLoading.value = false; // Stop loading in case of error
  //     print("Error fetching tickets: $error");
  //   });
  // }

  Future<void> checkNearbyTickets() async {
    isLoading.value = true;
    Position currentPosition = await _determinePosition();

    FirebaseFirestore.instance
        .collection('tickets')
        .where('private', isEqualTo: false)
        .get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((ticket) async {
            String ticketLocationAddress = ticket.get('location');
            List<Location> locations = await locationFromAddress(
              ticketLocationAddress,
            );

            if (locations.isNotEmpty) {
              Location ticketLocation = locations.first;
              double distance = Geolocator.distanceBetween(
                currentPosition.latitude,
                currentPosition.longitude,
                ticketLocation.latitude,
                ticketLocation.longitude,
              );

              if (distance <= 50000000000000) {
                DateTime eventDateTime =
                    (ticket.get('date') as Timestamp).toDate();
                DateTime now = DateTime.now();

                if (eventDateTime.isBefore(DateTime.now())) {
                  nearbyPastEvents.add(
                    TicketInfo(
                      id: ticket.id,
                      eventName: ticket.get('eventName'),
                      photoURL: ticket.get('photoURL'),
                      location: ticket.get('location'),
                      date: ticket.get('date'),
                      familyPrice: ticket.get('familyPrice'),
                      startTime: ticket.get('startTime'),
                      endTime: ticket.get('endTime'),
                      childPrice: ticket.get('childPrice'),
                      adultPrice: ticket.get('adultPrice'),
                      description: ticket.get('description'),
                      organizarImage: ticket.get('userProfilePic'),
                      isFollow: ticket.get('isEventFavourite'),
                      organizarName: ticket.get('userName'),
                      isPaid: ticket.get('isPaid'),
                      ticketUid: ticket.get('uid'),
                    ),
                  );
                } else {
                  if (eventDateTime.year == now.year &&
                      eventDateTime.month == now.month) {
                    nearbyNextEvents.add(
                      TicketInfo(
                        id: ticket.id,
                        eventName: ticket.get('eventName'),
                        photoURL: ticket.get('photoURL'),
                        location: ticket.get('location'),
                        date: ticket.get('date'),
                        familyPrice: ticket.get('familyPrice'),
                        startTime: ticket.get('startTime'),
                        endTime: ticket.get('endTime'),
                        childPrice: ticket.get('childPrice'),
                        adultPrice: ticket.get('adultPrice'),
                        description: ticket.get('description'),
                        organizarImage: ticket.get('userProfilePic'),
                        isFollow: ticket.get('isEventFavourite'),
                        organizarName: ticket.get('userName'),
                        isPaid: ticket.get('isPaid'),
                        ticketUid: ticket.get('uid'),
                      ),
                    );
                  }
                }
              }
            }
          });
          isLoading.value = false;
        });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final TicketController ticketController = Get.put(TicketController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                children: [
                  Text(
                    'Upcoming Events',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
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
                    'Events happening this month',
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
            isLoading.value
                ? Center(child: CircularProgressIndicator())
                : nearbyNextEvents.isEmpty
                ? const Center(child: Text('No upcoming events near me'))
                : nearbyNextEvents.isEmpty
                ? const Center(child: Text('No nearby tickets found.'))
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: nearbyNextEvents.length,
                  itemBuilder: (context, index) {
                    TicketInfo ticket = nearbyNextEvents[index];
                    RxBool isFavorite = false.obs;
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ArcadeScreen(
                            photoURL: ticket.photoURL,
                            eventName: ticket.eventName,
                            location: ticket.location,
                            adultPrice: ticket.adultPrice,
                            childPrice: ticket.childPrice,
                            date: ticket.date,
                            endTime: ticket.endTime,
                            familyPrice: ticket.familyPrice,
                            description: ticket.description,
                            startTime: ticket.startTime,
                            isPaid: ticket.isPaid,
                            OrganizerProfilePic: ticket.organizarImage,
                            oragnizerName: ticket.organizarName,
                            ticketUid: ticket.ticketUid,
                            isEventFavourite: ticket.isFollow,
                          ),
                        );

                        // Get.to(
                        //   () => DataTransfer(
                        //     name: ticket.eventName,
                        //     photoUrl: ticket.photoURL,
                        //     location: ticket.location,
                        //     date: ticket.date,
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ticket.eventName.length > 35
                                                ? '${ticket.eventName.substring(0, 35)}..'
                                                : ticket.eventName,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 0.3.h),
                                          // Row(
                                          //   children: [
                                          //     GradientText(
                                          //       text: "+200 Going",
                                          //       gradient:
                                          //           const LinearGradient(
                                          //         colors: [
                                          //           Color(0xffFF0092),
                                          //           Color(0xff216DFD),
                                          //         ],
                                          //       ),
                                          //       style: GoogleFonts.inter(
                                          //         fontWeight:
                                          //             FontWeight.w400,
                                          //         fontSize: 10,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          SizedBox(height: 0.3.h),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svgs/home/map-pin.svg',
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                ticket.location.length > 30
                                                    ? '${ticket.location.substring(0, 30)}..'
                                                    : ticket.location,
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(),
                                          const Spacer(),
                                          // Row(
                                          //   children: [
                                          //     Image.asset(
                                          //         'assets/pngs/Vector.png'),
                                          //     const SizedBox(width: 3),
                                          //     Text(
                                          //       'Trending',
                                          //       style: GoogleFonts.inter(
                                          //         fontSize: 10,
                                          //         color: const Color(
                                          //             0xff025B8F),
                                          //         fontWeight:
                                          //             FontWeight.w400,
                                          //       ),
                                          //     ),
                                          //     const SizedBox(width: 10),
                                          //     Image.asset(
                                          //         'assets/pngs/material-symbols_upcoming-outline.png'),
                                          //     const SizedBox(width: 3),
                                          //     Text(
                                          //       'Trending',
                                          //       style: GoogleFonts.inter(
                                          //         fontSize: 10,
                                          //         color: const Color(
                                          //             0xff025B8F),
                                          //         fontWeight:
                                          //             FontWeight.w400,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // SizedBox(height: 1.h),
                                          // Row(
                                          //   children: [
                                          //     Image.asset(
                                          //         'assets/pngs/majesticons_music.png'),
                                          //     const SizedBox(width: 3),
                                          //     Text(
                                          //       'Hip-hop',
                                          //       style: GoogleFonts.inter(
                                          //         fontSize: 10,
                                          //         color: const Color(
                                          //             0xff025B8F),
                                          //         fontWeight:
                                          //             FontWeight.w400,
                                          //       ),
                                          //     ),
                                          //     const SizedBox(width: 10),
                                          //     Image.asset(
                                          //         'assets/pngs/majesticons_music-line.png'),
                                          //     const SizedBox(width: 3),
                                          //     Text(
                                          //       'Hot',
                                          //       style: GoogleFonts.inter(
                                          //         fontSize: 10,
                                          //         color: const Color(
                                          //             0xff025B8F),
                                          //         fontWeight:
                                          //             FontWeight.w400,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // SizedBox(height: 1.h),
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
                                  image: NetworkImage(ticket.photoURL),
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
                                        isFavorite.value = true;

                                        ticketController.updateTicketCollection(
                                          ticket.id.obs,
                                          isFavorite.value.obs,
                                        );
                                        isFavorite.toggle();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: const Color(
                                          0xff80ffff,
                                        ),
                                        radius: 16,
                                        child: Icon(
                                          size: 2.5.h,
                                          ticket.isFollow
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                children: [
                  Text(
                    'Past Events',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
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
                    'Event happened in Past',
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
            isLoading.value
                ? Center(child: CircularProgressIndicator())
                : nearbyPastEvents.isEmpty
                ? const Center(child: Text('no events in Past near me'))
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: nearbyPastEvents.length,
                  itemBuilder: (context, index) {
                    TicketInfo ticket = nearbyPastEvents[index];
                    RxBool isFavorite = false.obs;
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ArcadeScreen(
                            photoURL: ticket.photoURL,
                            eventName: ticket.eventName,
                            location: ticket.location,
                            adultPrice: ticket.adultPrice,
                            childPrice: ticket.childPrice,
                            date: ticket.date,
                            endTime: ticket.endTime,
                            familyPrice: ticket.familyPrice,
                            description: ticket.description,
                            startTime: ticket.startTime,
                            isPaid: ticket.isPaid,
                            OrganizerProfilePic: ticket.organizarImage,
                            oragnizerName: ticket.organizarName,
                            ticketUid: ticket.ticketUid,
                            isEventFavourite: ticket.isFollow,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ticket.eventName.length > 35
                                                ? '${ticket.eventName.substring(0, 35)}..'
                                                : ticket.eventName,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 0.3.h),
                                          SizedBox(height: 0.3.h),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svgs/home/map-pin.svg',
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                ticket.location.length > 30
                                                    ? '${ticket.location.substring(0, 30)}..'
                                                    : ticket.location,
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [Container(), const Spacer()],
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
                                  image: NetworkImage(ticket.photoURL),
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
                                        isFavorite.value = true;
                                        ticketController.updateTicketCollection(
                                          ticket.id.obs,
                                          isFavorite.value.obs,
                                        );
                                        isFavorite.toggle();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: const Color(
                                          0xff80ffff,
                                        ),
                                        radius: 16,
                                        child: Icon(
                                          size: 2.5.h,
                                          ticket.isFollow
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
