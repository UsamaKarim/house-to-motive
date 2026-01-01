import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../core/constants/color.dart';



class ticketScreens extends StatelessWidget {
  const ticketScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F9FF),
      appBar: AppBar(
        backgroundColor: seagreen,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
           // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyFavourites()));
          },
        ),
        flexibleSpace: const Image(
          image: AssetImage('assets/assets2/images/Pasted image.png'),
          fit: BoxFit.cover,
        ),
        title: Text('My Tickets',
            style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
        centerTitle: true,

      ),

      body: Center(child:   Text(
        'Coming Soon...',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),)
      // Padding(
      //   padding: const EdgeInsets.all(15.0),
      //   child: ListView.builder(
      //     itemCount: 3,
      //     itemBuilder: (context, index) {
      //       return TicketTile(
      //           context,
      //           Name2[index],
      //           date[index],
      //           price[index],
      //           member[index],
      //           loc[index],
      //           Category1[index],
      //           Category2[index],
      //           disc[index]);
      //     },
      //   ),
      // ),
    );
  }
}
