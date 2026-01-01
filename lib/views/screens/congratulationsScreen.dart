// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
//
// class congratulationScreen extends StatelessWidget {
//   const congratulationScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//             horizontal: MediaQuery.of(context).size.width / 16),
//         child: Column(
//           children: [
//             SizedBox(
//               height: size.height / 40,
//             ),
//             Center(child: SvgPicture.asset("assets/congrat.svg")),
//             SizedBox(
//               height: size.height / 40,
//             ),
//             Text(
//               "Congratulations!",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700),
//             ),
//             SizedBox(
//               height: size.height / 40,
//             ),
//             Text(
//               "You have successfully purchased a ticked for NQ64 Arcade, we have sent ticket to your email address.",
//               style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black.withOpacity(0.7)),
//             ),
//             SizedBox(
//               height: size.height / 20,
//             ),
//             // ElevatedButton(
//             //   style: ElevatedButton.styleFrom(
//             //     shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(20),
//             //     ),
//             //     fixedSize: const Size(180, 50),
//             //     backgroundColor: const Color(0xff025B8F),
//             //   ),
//             //   onPressed: () {
//             //     Get.back();
//             //   },
//             //   child: const Center(
//             //     child: Text(
//             //       "Go back to Home",
//             //       style: TextStyle(color: Colors.white),
//             //     ),
//             //   ),
//             // ),
//             GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: Container(
//                 height: 50.px,
//                 width: 180.px,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: const Color(0xff025B8F),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Go back to Home",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
