import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/views/login/loginwith_email.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../login/allow_location.dart';

class IntroScreenOne extends StatefulWidget {
  const IntroScreenOne({super.key});

  @override
  State<IntroScreenOne> createState() => _IntroScreenOneState();
}

class _IntroScreenOneState extends State<IntroScreenOne> {
  Future<void> requestTrackingPermission() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      // Show the tracking authorization prompt
      final newStatus =
          await AppTrackingTransparency.requestTrackingAuthorization();
      debugPrint('Tracking Authorization Status: $newStatus');
    } else {
      debugPrint('Tracking Authorization Status: $status');
    }

    // Optionally, get and log the IDFA
    final idfa = await AppTrackingTransparency.getAdvertisingIdentifier();
    debugPrint('Advertising Identifier: $idfa');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestTrackingPermission();
  }

  @override
  Widget build(BuildContext context) {
    var pageController = PageController().obs;
    var pageController1 = PageController().obs;
    int currentIndex = 0;
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 3.h),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController.value,
              onPageChanged: (value) {
                currentIndex = value;
              },
              children: [
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/pngs/htmimage1.png',
                      ),
                    ),
                    Image.asset('assets/pngs/Group 33331.png')
                  ],
                ),
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/pngs/htmimage1.png',
                      ),
                    ),
                    Image.asset('assets/pngs/Group 333331.png')
                  ],
                ),
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/pngs/htmimage1.png',
                      ),
                    ),
                    Image.asset('assets/pngs/Group 33331 (1).png'),
                  ],
                ),
                // Image.asset('assets/pngs/Group 333331.png'),
                // Image.asset('assets/pngs/Group 33331 (1).png'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(48),
                  topLeft: Radius.circular(48),
                ),
                color: Color(0xff025B8F),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/pngs/Group 1171274984 - 1.png'),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: pageController1.value,
                            onPageChanged: (value) {
                              currentIndex = value;
                            },
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    ' Explore Upcoming and Nearby Events',
                                    style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    '  In publishing and graphic design, Lorem is a placeholder text commonly ',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xffFFFFFF),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    ' Explore Upcoming and Nearby Events',
                                    style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    '  In publishing and graphic design, Lorem is a placeholder text commonly ',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xffFFFFFF),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    ' Explore Upcoming and Nearby Events',
                                    style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    '  In publishing and graphic design, Lorem is a placeholder text commonly ',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xffFFFFFF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => LoginWithEmailScreen());
                                },
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Skip',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white38,
                                  ),
                                ),
                              ),
                              SmoothPageIndicator(
                                effect: const SlideEffect(
                                  activeDotColor: Colors.white,
                                  dotHeight: 10,
                                  dotWidth: 10,
                                ),
                                controller: pageController.value,
                                count: 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (currentIndex == 0) {
                                    pageController.value.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                    pageController1.value.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  } else if (currentIndex == 1) {
                                    pageController.value.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                    pageController1.value.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  } else {
                                    Get.to(() => AllowLocationScreen());
                                  }
                                },
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Next',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset('assets/pngs/Group 1171274984.png'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
