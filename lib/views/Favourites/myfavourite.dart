import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../views/screens/home_screens/home_model.dart';

class FavRestaurants extends StatelessWidget {
  const FavRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: foodnearby.length,
          itemBuilder: (context, index) {
            // VideoUrls vdourls = videoUrls[index];
            return GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.26,
                        width: screenWidth / 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    foodnearby[index].city,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '£${foodnearby[index].price}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff025B8F),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.3.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GradientText(
                                    text: "${foodnearby[index].mile} mile",
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffFF0092),
                                        Color(0xff216DFD),
                                      ],
                                    ),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.3.h),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/home/map-pin.svg',
                                  ),
                                  SizedBox(width: 0.3.h),
                                  Text(
                                    foodnearby[index].location,
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
                        width: Get.width / 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(foodnearby[index].image),
                          ),
                          // color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 3.5.h,
                                width: 8.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xff80FFFF),
                                  border: Border.all(color: Colors.white60),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/home/Star 2.svg',
                                    ),
                                    Text(
                                      foodnearby[index].rating,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: const Color(0xff80FFFF),
                                radius: 16,
                                child: SvgPicture.asset(
                                  'assets/svgs/home/Vector.svg',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
