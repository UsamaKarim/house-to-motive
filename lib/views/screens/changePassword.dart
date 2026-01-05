import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/widgets/loginbutton.dart';

class ChangePassWordScreen extends StatelessWidget {
  ChangePassWordScreen({super.key});

  TextEditingController oldPassword = TextEditingController();
  TextEditingController NewPassword = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Color(0xffF6F9FF),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 19,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff025B8F),
        title: Text(
          'Change Password',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Old Password",
              style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(2, 91, 143, 1)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            CustomTextFeild(context, 'Confirm ', oldPassword),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.043,
            ),
            Text(
              "New Password",
              style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(2, 91, 143, 1)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.019,
            ),
            CustomTextFeild(context, 'Confirm ', NewPassword),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.019,
            ),
            CustomTextFeild(context, 'Confirm Password ', ConfirmPassword),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.019,
            ),
            Text(
                "Password must have 8 digits mix of characters, numbers and symbols.",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff7390A1))),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            // Container(
            //     width: MediaQuery.of(context).size.width*0.9,
            //     height: MediaQuery.of(context).size.height*0.079,
            //     child: Center(
            //       child: Text(
            //           "Update Password",
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //             color: Colors.white,
            //           )
            //       ),
            //     ),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         color: Color(0xff025b8f)
            //     ),
            // ),
            CustomButton(title: 'Update Password', ontap: () {}),
          ],
        ),
      ),
    );
  }
}

Widget CustomTextFeild(
    BuildContext context, String hintText, TextEditingController cnt) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.06,
    width: MediaQuery.of(context).size.width * 0.9,
    child: TextFormField(
      controller: cnt,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'ProximaNova',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff7390A1),
        ),
        suffixIcon: Icon(
          Icons.visibility_off,
          color: Color(0xff7390A1).withOpacity(0.3),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFF7390A1).withOpacity(0.3))),
      ),
    ),
  );
}
