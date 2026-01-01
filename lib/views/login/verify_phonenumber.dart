import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:house_to_motive/views/login/update_password.dart';
import 'package:pinput/pinput.dart';

class VerifyPhoneNumberScreen extends StatelessWidget {
  const VerifyPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.31,
            child: Stack(
              children: [
                // Image.asset('assets/pngs/htmimage.png'),
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
                  '00:46',
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
                  "Type the verification code  we’ve sent youat +923484812310",
                  style: TextStyle(
                    fontFamily: 'ProximaNova',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff424B5A),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    textStyle: const TextStyle(fontSize: 22),
                    height: 56,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: Color(0xff025B8F)
                      border: Border.all(color: Colors.black38),
                      // color: Colors.black38
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const UpdatePasswordScreen());
                  },
                  child: const Text(
                    "Send Again",
                    style: TextStyle(
                      fontFamily: 'ProximaNova',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff025B8F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
