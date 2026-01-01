import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:house_to_motive/utils/utils.dart';
import 'package:house_to_motive/views/login/loginwith_email.dart';
import 'package:house_to_motive/views/login/verify_phonenumber.dart';
import 'package:house_to_motive/widgets/loginbutton.dart';

import '../../widgets/custom_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
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
                            Get.back();
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
                      'Forgot Password?',
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
                      "Enter email / phone number.We will send you a 6-digit code to verify your account.",
                      style: TextStyle(
                        fontFamily: 'ProximaNova',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff424B5A),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomEmailField(
                        title: 'Email', textEditingController: emailController),
                    SizedBox(height: screenHeight * 0.03),
                    CustomButton(
                      title: 'Reset Password',
                      ontap: () {
                        auth
                            .sendPasswordResetEmail(
                                email: emailController.text.toString())
                            .then((value) {
                          Get.to(() => LoginWithEmailScreen());
                          Utils().ToastMessage('please check your email');
                        }).onError((error, stackTrace) {
                          Utils().ToastMessage(error.toString());
                        });
                      },
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
                            Get.to(() => const VerifyPhoneNumberScreen());
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
            ],
          ),
        ),
      ),
    );
  }
}
