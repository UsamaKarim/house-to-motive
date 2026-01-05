// import 'package:elevated_ticket_widget/elevated_ticket_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../constants/color.dart';
//
// Widget TicketCard(BuildContext context, String name2, String date, String price,
//     int members, String location, String cate1, String cate2, String disc) {
//   return ElevatedTicketWidget(
//    height: 206.h,
//     width: 367.07.w,
//     child: Card(
//       shape: BorderDirectional(bottom: BorderSide(color: orange)),
//       color: Colors.white,
//       child: Padding(
//         padding: EdgeInsets.only(left: 10, right: 10, bottom: 6, top: 10).r,
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   name2,
//                   style: GoogleFonts.inter(
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 Text(
//                   price,
//                   style: GoogleFonts.inter(
//                       color: seagreen,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12.sp),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * .02,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 RichText(
//                     text: TextSpan(
//                         style: GoogleFonts.inter(
//                             color: grey,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.w500),
//                         children: <TextSpan>[
//                           TextSpan(text: cate1),
//                           TextSpan(text: cate2, style: TextStyle(color: orange))
//                         ])),
//                 Text(
//                   disc,
//                   style: GoogleFonts.inter(
//                     color: grey,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 10.sp,
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 12.h,
//             ),
//             Divider(
//               color: dividerColor,
//               height: 12.h, // height of the divider
//               thickness: 2, // thickness of the divider
//               indent: 20, // left indentation of the divider
//               endIndent: 10, // right indentation of the divider
//             ),
//             SizedBox(
//               height: 12.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Name',
//                   style: GoogleFonts.inter(
//                       color: grey, fontSize: 10.sp, fontWeight: FontWeight.w400),
//                 ),
//                 Text(
//                   'Date',
//                   style: GoogleFonts.inter(
//                       color: grey, fontSize: 10.sp, fontWeight: FontWeight.w400),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 6.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Oyinola Agoro',
//                   style: GoogleFonts.inter(
//                     fontSize: 12.sp,
//                     color: blck,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   date,
//                   style: GoogleFonts.inter(
//                     fontSize: 12.sp,
//                     color: blck,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 9.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Location',
//                   style: GoogleFonts.inter(
//                     fontWeight: FontWeight.w200,
//                     fontSize: 10.sp,
//                     color: grey,
//                   ),
//                 ),
//                 Text(
//                   'Members',
//                   style: GoogleFonts.inter(
//                     fontWeight: FontWeight.w200,
//                     fontSize: 10.sp,
//                     color: grey,
//                   ),
//                 )
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   location,
//                   style: GoogleFonts.inter(
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   members.toString(),
//                   style: GoogleFonts.inter(
//                       fontSize: 13.sp, fontWeight: FontWeight.bold, color: blck),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 10.h,
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: Container(
//                 width: 312.w,
//                 height: 28.h,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(7),
//                     color: Color(0xff025b8f)),
//                 child: Center(
//                   child: Text("View Details",
//                       style: TextStyle(
//                         fontSize: 10.sp,
//                         fontWeight: FontWeight.w400,
//                       )),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }
