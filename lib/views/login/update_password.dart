import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:house_to_motive/views/createan_account/signup_screen.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/loginbutton.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.31,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      'assets/pngs/htmimage1.png',
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/svgs/splash-logo.png',
                      width: 144,
                      height: 144,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 50,
                    child: InkWell(
                        onTap: () {
                          // Get.back();
                        },
                        child: SvgPicture.asset(
                          'assets/svgs/back_btn.svg',
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                children: [
                  const Text(
                    'Update Password',
                    style: TextStyle(
                      fontFamily: 'Mont',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff025B8F),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  const Text(
                    textAlign: TextAlign.center,
                    "Password must have 8 digits mix of characters, numbers and symbols.",
                    style: TextStyle(
                      fontFamily: 'ProximaNova',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff424B5A),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const CustomPasswordField(title: 'Enter password'),
                  SizedBox(height: screenHeight * 0.01),
                  const CustomPasswordField(
                    title: 'Confirm password',
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  CustomButton(
                    title: "Update Password",
                    ontap: () {
                      Get.to(() => SignupScreen());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
