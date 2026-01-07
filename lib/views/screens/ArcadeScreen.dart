import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/controller/event_controller.dart';
import 'package:house_to_motive/controller/get_video_controller.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ArcadeScreen extends StatefulWidget {
  final description;
  final photoURL;
  final startTime;
  final endTime;
  final eventName;
  final location;
  final date;
  final familyPrice;
  final adultPrice;
  final childPrice;
  final oragnizerName;
  final OrganizerProfilePic;
  final ticketUid;
  final isEventFavourite;
  final isPaid;
  final id;
  const ArcadeScreen({
    Key? key,
    this.description,
    this.photoURL,
    this.startTime,
    this.endTime,
    this.eventName,
    this.location,
    this.date,
    this.familyPrice,
    this.adultPrice,
    this.childPrice,
    this.oragnizerName,
    this.OrganizerProfilePic,
    this.ticketUid,
    this.isEventFavourite,
    this.isPaid,
    this.id,
  }) : super(key: key);

  @override
  State<ArcadeScreen> createState() => _ArcadeScreenState();
}

class _ArcadeScreenState extends State<ArcadeScreen> {
  final GetVideoController getVideoController = Get.put(GetVideoController());

  String? userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    DateTime date = widget.date.toDate();

    // Format the DateTime to a string
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final Size size = MediaQuery.of(context).size;
    TicketController ticketController = Get.put(TicketController());
    log('userId: ${widget.ticketUid.toString()}');
    return Scaffold(
      backgroundColor: const Color(0xffF6F9FF),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 500,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: Get.width,
                    height: Get.height / 3,
                    child: Image.network(widget.photoURL, fit: BoxFit.fill),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 4.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(1.h),
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: const Color(0xff80ffff),
                              radius: 16,
                              child: Icon(
                                size: 2.5.h,
                                widget.isEventFavourite == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    Colors.red, // Customize the color as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: size.height / 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.eventName,
                            style: GoogleFonts.inter(
                              fontSize: 20.px,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height / 40),
                    Row(
                      children: [
                        SvgPicture.asset("assets/Location.svg"),
                        const SizedBox(width: 9),
                        Flexible(
                          // Wrap the Text widget with Flexible
                          child: Text(
                            widget.location,
                            style: GoogleFonts.inter(
                              fontSize: 14.px,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff707B81),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height / 100),
                    Row(
                      children: [
                        SvgPicture.asset("assets/stopwatch.svg"),
                        Flexible(
                          child: Text(
                            "  Open: ${widget.startTime} - ${widget.endTime}",
                            style: GoogleFonts.inter(
                              fontSize: 14.px,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff707B81),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height / 40),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          widget.OrganizerProfilePic.toString().isEmpty
                              ? "https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg"
                              : widget.OrganizerProfilePic.toString(),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height / 90),
                          Text(
                            widget.oragnizerName.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: size.height / 80),
                          const Text(
                            "Organizer",
                            style: TextStyle(
                              color: Color(0xff8A8B8F),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing:
                          userId == widget.ticketUid
                              ? const SizedBox.shrink()
                              : Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Color(0xffFF0092),
                                        Color(0xff216DFD),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: GestureDetector(
                                    onTap: () async {
                                      // Toggle follow status and get the updated status
                                      bool updatedFollowStatus =
                                          await ticketController
                                              .toggleFollowUser(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                                widget.ticketUid,
                                              );

                                      getVideoController.isFollowing.value =
                                          updatedFollowStatus;
                                    },
                                    child: Obx(
                                      () => Center(
                                        child: Text(
                                          getVideoController.isFollowing.value
                                              ? "Unfollow"
                                              : "Follow",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                    ),
                    // SizedBox(
                    //   height: 2.h,
                    // ),
                    //
                    // widget.isPaid!=true?const SizedBox.shrink():  Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "Tickets Type",
                    //     style: GoogleFonts.inter(
                    //       fontSize: 18.px,
                    //       fontWeight: FontWeight.w700,
                    //       color: const Color(0xff3D3D3D),
                    //     ),
                    //   ),
                    // ),
                    // widget.isPaid!=true?const SizedBox.shrink(): SizedBox(
                    //   height: size.height / 40,
                    // ),
                    // widget.isPaid!=true?const SizedBox.shrink():Obx(()=>
                    //    SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child:  Row(
                    //       children: [
                    //         InkWell(
                    //           onTap: () {
                    //             isSelected.value='child';
                    //             selectedTicketPrice.value=widget.childPrice;
                    //
                    //             // Navigator.push(
                    //             //   context,
                    //             //   MaterialPageRoute(
                    //             //     builder: (_) => const ticketDetails(),
                    //             //   ),
                    //             // );
                    //           },
                    //           child: Container(
                    //             height: size.height / 14,
                    //             width: size.width / 3,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(8.0),
                    //                 color: const Color(0xffE45900),
                    //                 border: Border.all(width: 2.5,
                    //                     color:isSelected.value=='child'? const Color(0xff216DFD):Colors.transparent)
                    //             ),
                    //             child: Column(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceEvenly,
                    //               children: [
                    //                 const Text(
                    //                   "Child",
                    //                   style: TextStyle(
                    //                       color: Colors.white, fontSize: 12),
                    //                 ),
                    //                 Text(
                    //                   "£${widget.childPrice.toString().isEmpty ? "free" : widget.childPrice}",
                    //                   style: const TextStyle(
                    //                       color: Colors.white,
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: size.width / 40,
                    //         ),
                    //         InkWell(
                    //           onTap: () {
                    //             isSelected.value='adult';
                    //             selectedTicketPrice.value=widget.adultPrice;
                    //
                    //             // Navigator.push(
                    //             //     context,
                    //             //     MaterialPageRoute(
                    //             //         builder: (_) => const ticketDetails()));
                    //           },
                    //           child: Container(
                    //             height: size.height / 14,
                    //             width: size.width / 3,
                    //             decoration: BoxDecoration(
                    //                 gradient: const LinearGradient(colors: [
                    //                   Color(0XFF4ADE80),
                    //                   Color(0XFF256F40)
                    //                 ]),
                    //                 borderRadius: BorderRadius.circular(8.0),
                    //                 color: const Color(0xffE45900),
                    //                 border: Border.all(width: 2.5,
                    //                     color:isSelected.value=='adult'? const Color(0xff216DFD):Colors.transparent)
                    //             ),
                    //             child: Column(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceEvenly,
                    //               children: [
                    //                 const Text("Adult",
                    //                     style: TextStyle(
                    //                         color: Colors.white, fontSize: 12)),
                    //                 Text(
                    //                     "£${widget.adultPrice.toString().isEmpty ? "Free" : widget.adultPrice}",
                    //                     style: const TextStyle(
                    //                         color: Colors.white,
                    //                         fontSize: 12,
                    //                         fontWeight: FontWeight.bold)),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: size.width / 40,
                    //         ),
                    //         InkWell(
                    //           onTap: () {
                    //             isSelected.value='family';
                    //             selectedTicketPrice.value=widget.familyPrice;
                    //
                    //
                    //             // Get.to(() => const ticketDetails());
                    //           },
                    //           child: Container(
                    //             height: size.height / 14,
                    //             width: size.width / 3,
                    //             decoration: BoxDecoration(
                    //                 gradient: const LinearGradient(colors: [
                    //                   Color(0XFFFBD22F),
                    //                   Color(0XFFC89F00)
                    //                 ]),
                    //                 borderRadius: BorderRadius.circular(8.0),
                    //                 color: const Color(0xffE45900),
                    //             border: Border.all(width: 2.5,
                    //                 color:isSelected.value=='family'? const Color(0xff216DFD):Colors.transparent)
                    //             ),
                    //             child: Column(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceEvenly,
                    //               children: [
                    //                 const Text(
                    //                   "Family",
                    //                   style: TextStyle(
                    //                       color: Colors.white, fontSize: 12),
                    //                 ),
                    //                 Text(
                    //                   "£${widget.familyPrice.toString().isEmpty ? "Free" : widget.familyPrice}",
                    //                   style: const TextStyle(
                    //                       color: Colors.white,
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: size.height / 60),
                    //
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Time and Venue",
                        style: GoogleFonts.inter(
                          fontSize: 18.px,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff3D3D3D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: MediaQuery.of(context).size.width / 2,
                    //       child: ListTile(
                    //         leading: SvgPicture.asset("assets/Date.svg"),
                    //         title: Text(formattedDate,
                    //             style: TextStyle(
                    //                 fontSize: 12, color: Colors.black)),
                    //         // SizedBox(height: size.height / 55),
                    //         subtitle: const Text(
                    //           "Sunday, 5:30PM - 7:30PM",
                    //           style: TextStyle(
                    //               fontSize: 8, color: Color(0XFF707B81)),
                    //         ),
                    //
                    //       ),
                    //     ),
                    //     // const SizedBox(
                    //     //     width:
                    //     //         8.0), // Adjust the spacing between ListTiles
                    //     SizedBox(
                    //       width: MediaQuery.of(context).size.width / 2,
                    //       child: ListTile(
                    //         leading: SvgPicture.asset("assets/loc.svg"),
                    //         title: const Text("158 The Green",
                    //             style: TextStyle(
                    //                 fontSize: 12, color: Colors.black)),
                    //         // SizedBox(height: size.height / 55),
                    //         subtitle: const Text(
                    //           "Eko Hotel and Suite. VI",
                    //           style: TextStyle(
                    //               fontSize: 8, color: Color(0XFF707B81)),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset("assets/Date.svg"),
                                    SizedBox(width: 1.5.h),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formattedDate.isEmpty
                                              ? "no date"
                                              : formattedDate,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        const Text(
                                          "Sunday, 5:30PM - 7:30PM",
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: Color(0XFF707B81),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 1.5.h),
                                Row(
                                  children: [
                                    SvgPicture.asset("assets/loc.svg"),
                                    SizedBox(width: 1.5.h),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "158 The Green",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          widget.location.length > 20
                                              ? widget.location.substring(
                                                    0,
                                                    20,
                                                  ) +
                                                  '..'
                                              : widget.location,
                                          style: const TextStyle(
                                            fontSize: 8,
                                            color: Color(0XFF707B81),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: size.height / 40,
                    // ),

                    // Container(
                    //   height: size.height / 11,
                    //   color: Colors.white,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       const SizedBox(
                    //         width: 100,
                    //         child: Stack(
                    //           children: [
                    //             Positioned(
                    //               left: 40,
                    //               child: CircleAvatar(
                    //                 radius: 20,
                    //                 backgroundImage:
                    //                     AssetImage("assets/model2.jpg"),
                    //               ),
                    //             ),
                    //             Positioned(
                    //               left: 20,
                    //               child: CircleAvatar(
                    //                 radius: 20,
                    //                 backgroundImage:
                    //                     AssetImage("assets/model1.jpg"),
                    //               ),
                    //             ),
                    //             CircleAvatar(
                    //               radius: 20,
                    //               backgroundImage:
                    //                   AssetImage("assets/model2.jpg"),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       ShaderMask(
                    //         shaderCallback: (Rect bounds) {
                    //           return const LinearGradient(
                    //             colors: [
                    //               Color(0xffFF0092),
                    //               Color(0xff216DFD)
                    //             ],
                    //           ).createShader(bounds);
                    //         },
                    //         child: const Text(
                    //           "780 Attending",
                    //           style: TextStyle(
                    //               fontSize: 15,
                    //               fontWeight: FontWeight.w700,
                    //               color: Colors.white),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: size.width / 6,
                    //       ),
                    //       Container(
                    //         width: MediaQuery.of(context).size.width * 0.2,
                    //         height: 35,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             color: Colors.grey.shade200),
                    //         child: ShaderMask(
                    //           shaderCallback: (Rect bounds) {
                    //             return const LinearGradient(
                    //               colors: [
                    //                 Color(0xffFF0092),
                    //                 Color(0xff216DFD)
                    //               ],
                    //             ).createShader(bounds);
                    //           },
                    //           child: const Center(
                    //             child: Text(
                    //               "Invite",
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w700,
                    //                   color: Colors.white),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: size.height / 40,
                    // ),
                    // Container(
                    //   height: size.height / 11,
                    //   color: Colors.white,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       const SizedBox(
                    //         width: 100,
                    //         child: Stack(
                    //           children: [
                    //             Positioned(
                    //               left: 40,
                    //               child: CircleAvatar(
                    //                 radius: 20,
                    //                 backgroundImage:
                    //                     AssetImage("assets/model1.jpg"),
                    //               ),
                    //             ),
                    //             Positioned(
                    //               left: 20,
                    //               child: CircleAvatar(
                    //                 radius: 20,
                    //                 backgroundImage:
                    //                     AssetImage("assets/model2.jpg"),
                    //               ),
                    //             ),
                    //             CircleAvatar(
                    //               radius: 20,
                    //               backgroundImage:
                    //                   AssetImage("assets/model2.jpg"),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       ShaderMask(
                    //         shaderCallback: (Rect bounds) {
                    //           return const LinearGradient(
                    //             colors: [
                    //               Color(0xffFF0092),
                    //               Color(0xff216DFD)
                    //             ],
                    //           ).createShader(bounds);
                    //         },
                    //         child: const Text(
                    //           "748 Followers",
                    //           style: TextStyle(
                    //               fontSize: 15,
                    //               fontWeight: FontWeight.w700,
                    //               color: Colors.white),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: size.width / 6,
                    //       ),
                    //       Container(
                    //         width: MediaQuery.of(context).size.width * 0.2,
                    //         height: 35,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             color: Colors.grey.shade200),
                    //         child: ShaderMask(
                    //           shaderCallback: (Rect bounds) {
                    //             return const LinearGradient(
                    //               colors: [
                    //                 Color(0xffFF0092),
                    //                 Color(0xff216DFD)
                    //               ],
                    //             ).createShader(bounds);
                    //           },
                    //           child: const Center(
                    //             child: Text(
                    //               "Follow",
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w700,
                    //                   color: Colors.white),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 30,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Description",
                    style: GoogleFonts.inter(
                      fontSize: 18.px,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff3D3D3D),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 30,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      color: Color(0XFF7390A1),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: size.height / 40,
              // ),
              // widget.isPaid!=true?const SizedBox.shrink(): ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     fixedSize: const Size(300, 50),
              //     backgroundColor: const Color(0xff025B8F),
              //   ),
              //   onPressed: () {
              //     if(selectedTicketPrice.value.isNotEmpty){
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (_) =>  ticketDetails(
              //             title:widget.eventName,
              //             ticketPrice: selectedTicketPrice.value,
              //           )));
              //     }else{
              //       Get.snackbar('Sorry', 'Please Select ticket first');
              //     }
              //
              //   },
              //   child:    Obx(()=>
              //     Text("Book Your Ticket - £${selectedTicketPrice.value}",
              //         style: const TextStyle(color: Colors.white)),
              //   ),
              // ),
              //
              //
              const SizedBox(height: 20, width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
