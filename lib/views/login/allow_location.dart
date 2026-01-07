import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:house_to_motive/views/login/loginwith_email.dart';
import 'package:house_to_motive/views/screens/explore_screen.dart';
import 'package:house_to_motive/widgets/loginbutton.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllowLocationScreen extends StatelessWidget {
  AllowLocationScreen({super.key});
  final placeApiController = Get.put(PlacesApi());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(2.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => LoginWithEmailScreen());
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xff424B5A),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              SvgPicture.asset("assets/svgs/location.svg"),
              SizedBox(height: 8.h),
              const Text(
                'Enable Your Location',
                style: TextStyle(
                  fontFamily: 'Mont',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff025B8F),
                ),
              ),
              SizedBox(height: 2.h),
              const Text(
                'Enable your location for optimize search so we can suggest best match for you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'ProximaNova',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff424B5A),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 6.4),
              CustomButton(
                title: 'Next',
                ontap: () {
                  placeApiController.determinePosition().then((value) {
                    Get.to(() => LoginWithEmailScreen());
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
