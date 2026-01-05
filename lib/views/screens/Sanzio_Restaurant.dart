import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SanzioRestaurant extends StatefulWidget {
  final String closingTime;
  final String restaurantName;
  final String openingTime;
  final String location;
  final String imageUrl;
  final String imageName;
  final String description;
  const SanzioRestaurant(
      {super.key,
      required this.closingTime,
      required this.restaurantName,
      required this.openingTime,
      required this.location,
      required this.imageUrl,
      required this.imageName,
      required this.description});

  @override
  State<SanzioRestaurant> createState() => _SanzioRestaurantState();
}

class _SanzioRestaurantState extends State<SanzioRestaurant> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 1.5,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 600,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(widget.imageUrl, fit: BoxFit.cover)),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 13.h,
                            width: 2.h,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(1.h),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0))
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
                          // SizedBox(
                          //   width: size.width / 1.8,
                          // ),
                          // SvgPicture.asset("assets/Frame 48095548.svg"),
                          // SizedBox(
                          //   width: size.width / 40,
                          // ),
                          // SvgPicture.asset("assets/Frame 48095547.svg"),
                        ],
                      ),
                      // SizedBox(
                      //   height: size.height / 50,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Row(
                      //     children: [
                      //       InkWell(
                      //         onTap: () {},
                      //         child: Container(
                      //           width: size.width / 3.5,
                      //           height: size.height / 20,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(25),
                      //             gradient: const LinearGradient(
                      //               colors: [
                      //                 Color(0xffFF0092),
                      //                 Color(0xff216DFD)
                      //               ],
                      //             ),
                      //           ),
                      //           child: InkWell(
                      //             onTap: () {
                      //               // Navigator.push(
                      //               //   context,
                      //               //   MaterialPageRoute(
                      //               //     builder: (_) => const ArcadeScreen(
                      //               //       description: '',
                      //               //       photoURL: '',
                      //               //       startTime: '',
                      //               //       endTime: '',
                      //               //       eventName: '',
                      //               //       location: '',
                      //               //       date: '',
                      //               //     ),
                      //               //   ),
                      //               // );
                      //             },
                      //             child: const Center(
                      //               child: Text(
                      //                 'Open Map',
                      //                 style: TextStyle(
                      //                     color: Colors.white, fontSize: 12),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       // SizedBox(
                      //       //   width: size.width / 2.2,
                      //       // ),
                      //       // InkWell(onTap: () {
                      //       //   Navigator.push(context, MaterialPageRoute(builder: (_)=>ArcadeScreen()));
                      //       // },
                      //       //   child: Container(
                      //       //     width: size.width / 5,
                      //       //     height: size.height / 20,
                      //       //     decoration: BoxDecoration(
                      //       //       borderRadius: BorderRadius.circular(25),
                      //       //       color: Color(0XFF21C663)
                      //       //     ),
                      //       //     child: InkWell(
                      //       //       onTap: () {
                      //       //         Navigator.push(context, MaterialPageRoute(builder: (_)=>ArcadeScreen()));
                      //       //       },
                      //       //       child: const Center(
                      //       //         child: Text(
                      //       //           'Open ',
                      //       //           style:
                      //       //           TextStyle(color: Colors.white, fontSize: 12),
                      //       //         ),
                      //       //       ),
                      //       //     ),
                      //       //   ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height / 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurantName.length > 15
                              ? "${widget.restaurantName.substring(0, 15)}..."
                              : widget.restaurantName,
                          style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        // Text(
                        //   "£43.99",
                        //   style: GoogleFonts.inter(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.w700,
                        //     color: const Color(0XFF025B8F),
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/Location.svg",
                        ),
                        Text(
                          widget.location.length > 15
                              ? "${widget.location.substring(0, 15)}..."
                              : widget.location,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff707B81),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 100,
                    ),
                    Row(
                      children: [
                        Image.asset("assets/stopwatch.png"),
                        Text(
                          "  Open: ${widget.openingTime.length > 15 ? "${widget.openingTime.substring(0, 15)}..." : widget.openingTime} - ${widget.closingTime.length > 15 ? "${widget.closingTime.substring(0, 15)}..." : widget.closingTime}",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff707B81),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 40,
                        ),
                        // Image.asset("assets/Star 2.png"),
                        // Text(
                        //   " 91 (5.0)",
                        //   style: GoogleFonts.inter(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.w400,
                        //     color: const Color(0xff707B81),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Description",
                        style: GoogleFonts.inter(
                          color: const Color(0xff3D3D3D),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    Text(
                      widget.description,
                      style: const TextStyle(
                          fontFamily: 'ProximaNova',
                          color: Color(0XFF7390A1),
                          fontSize: 12),
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     const SizedBox(
                    //       width: 100,
                    //       child: Stack(
                    //         children: [
                    //           Positioned(
                    //             left: 40,
                    //             child: CircleAvatar(
                    //               radius: 20,
                    //               backgroundImage:
                    //                   AssetImage("assets/model1.jpg"),
                    //             ),
                    //           ),
                    //           Positioned(
                    //             left: 20,
                    //             child: CircleAvatar(
                    //               radius: 20,
                    //               backgroundImage:
                    //                   AssetImage("assets/model2.jpg"),
                    //             ),
                    //           ),
                    //           CircleAvatar(
                    //             radius: 20,
                    //             backgroundImage:
                    //                 AssetImage("assets/model2.jpg"),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     ShaderMask(
                    //       shaderCallback: (Rect bounds) {
                    //         return const LinearGradient(
                    //           colors: [Color(0xffFF0092), Color(0xff216DFD)],
                    //         ).createShader(bounds);
                    //       },
                    //       child: const Text(
                    //         "369 Followers",
                    //         style: TextStyle(
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.w700,
                    //             color: Colors.white),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: size.width / 6,
                    //     ),
                    //     Container(
                    //       width: MediaQuery.of(context).size.width * 0.2,
                    //       height: 35,
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           color: Colors.grey.shade200),
                    //       child: ShaderMask(
                    //         shaderCallback: (Rect bounds) {
                    //           return const LinearGradient(
                    //             colors: [Color(0xffFF0092), Color(0xff216DFD)],
                    //           ).createShader(bounds);
                    //         },
                    //         child: const Center(
                    //           child: Text(
                    //             "Follow",
                    //             style: TextStyle(
                    //                 fontSize: 12,
                    //                 fontWeight: FontWeight.w700,
                    //                 color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
              // const Expanded(
              //   child: ReviewScreen(),
              // ),
            ],
          ),
        ),
      ),
    ));
  }
}
