import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:house_to_motive/views/createan_account/verify_phonenumber.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../widgets/loginbutton.dart';

class SignupWithPhoneNumberScreen extends StatelessWidget {
  const SignupWithPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
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
            const Text(
              'Enter Phone Number',
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
              'Please enter your valid phone number. We will send you a 6-digit code to verify your account. ',
              style: TextStyle(
                fontFamily: 'ProximaNova',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff424B5A),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.072,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (countryCode) {
                        print(countryCode.dialCode); // Prints the selected country code
                      },
                      initialSelection: 'US',
                      favorite: ['+1', 'US'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      textStyle: const TextStyle(color: Colors.black),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '0000 0000',
                          hintStyle: TextStyle(color: Color(0XFF7390A1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.068,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: Color(0xffD9D9D9),
            //       ),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.only(right: 8, left: 8),
            //       // child: InternationalPhoneNumberInput(
            //       //   onInputChanged: (PhoneNumber number) {},
            //       //   onInputValidated: (bool value) {},
            //       //   selectorConfig: const SelectorConfig(
            //       //     selectorType: PhoneInputSelectorType.DIALOG,
            //       //   ),
            //       //   ignoreBlank: false,
            //       //   autoValidateMode: AutovalidateMode.onUserInteraction,
            //       //   selectorTextStyle: const TextStyle(color: Colors.black),
            //       //   // initialValue: _phoneNumber,
            //       //   textFieldController: TextEditingController(),
            //       //   formatInput: false,
            //       //   keyboardType: const TextInputType.numberWithOptions(
            //       //       signed: true, decimal: true),
            //       //   inputDecoration: const InputDecoration(
            //       //     border: InputBorder.none,
            //       //     labelText: 'Phone Number',
            //       //     labelStyle: TextStyle(
            //       //       fontFamily: 'ProximaNova',
            //       //       fontSize: 14,
            //       //       fontWeight: FontWeight.w400,
            //       //       color: Color(0xff7390A1),
            //       //     ),
            //       //     // border: OutlineInputBorder(
            //       //     //   borderSide: BorderSide(),
            //       //     // ),
            //       //   ),
            //       // ),
            //     ),
            //   ),
            // ),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              title: "Continue",
              ontap: () {},
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Didn’t get the code? ',
                  style: TextStyle(
                    fontFamily: 'ProximaNova',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff424B5A),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const CreateaccVerifyNumberScreen());
                  },
                  child: const Text(
                    ' Resend Again',
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
          ],
        ),
      ),
    );
  }
}
