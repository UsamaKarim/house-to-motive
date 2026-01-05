import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screens/home_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
          'Notification',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svgs/notification.svg'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.14),
            Text(
              'Enable Notifications',
              style: TextStyle(
                fontFamily: 'Mont',
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xff025B8F),
              ),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor',
              style: TextStyle(
                fontFamily: 'ProximaNova',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff424B5A),
              ),
            )
          ],
        ),
      ),
    );
  }
}
