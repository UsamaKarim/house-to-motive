import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/widgets/custom_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../widgets/loginbutton.dart';

class ContactUSScreen extends StatelessWidget {
  const ContactUSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Contact Us',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:  BorderSide(color: Color(0xffD9D9D9),),
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'ProximaNova',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3F2D20),),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:  BorderSide(color: Color(0xffD9D9D9),),
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Emain address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:  BorderSide(color: Color(0xffD9D9D9),),
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'ProximaNova',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3F2D20),),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:  BorderSide(color: Color(0xffD9D9D9),),
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Select Subject",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:  BorderSide(color: Color(0xffD9D9D9),),
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'ProximaNova',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3F2D20),),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:  BorderSide(color: Color(0xffD9D9D9),),
                  ),
                  suffixIcon: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 10,
                    child: SvgPicture.asset(
                      'assets/svgs/rightt.svg',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write your message here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:  BorderSide(color: Color(0xffD9D9D9),),
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'ProximaNova',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3F2D20),),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:  BorderSide(color: Color(0xffD9D9D9),),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '00/250',
                    style: TextStyle(color: Colors.black38,fontSize: 10),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              CustomButton(
                title: 'Send',
                ontap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
