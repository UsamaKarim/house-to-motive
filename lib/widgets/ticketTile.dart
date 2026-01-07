import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core/constants/color.dart';

Widget TicketTile(
  BuildContext context,
  String name2,
  String date,
  String price,
  int members,
  String location,
  String cate1,
  String cate2,
  String disc,
) {
  var mqh = MediaQuery.of(context).size.height;
  var mqw = MediaQuery.of(context).size.width;

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(19),
      child: Container(
        decoration: const BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(color: orange, width: 2),
          ),
        ),
        child: Container(
          // elevation: 0,
          height: MediaQuery.of(context).size.height * .28,
          //height: 253.h,
          color: Colors.white,
          // width: 343.w,
          width: MediaQuery.of(context).size.width * .3,
          child: Column(
            children: [
              SizedBox(height: mqh * 0.01),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name2,
                      style: GoogleFonts.inter(
                        fontSize: 12.px,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.inter(
                        color: seagreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.px,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                // height: 10.h,
                height: MediaQuery.of(context).size.height * .01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          color: grey,
                          fontSize: 10.px,
                          fontWeight: FontWeight.w500,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: cate1),
                          TextSpan(
                            text: cate2,
                            style: const TextStyle(color: orange),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      disc,
                      style: GoogleFonts.inter(
                        decoration: TextDecoration.lineThrough,
                        color: grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.px,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .012),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: mqh * .028,
                    width: mqw * .044,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xffF6F9FF),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(50),
                      ),
                    ),
                  ),
                  Expanded(child: MySeparator(color: Color(0xFFE0E0E0))),
                  Container(
                    height: mqh * .028,
                    width: mqw * .044,
                    margin: const EdgeInsets.only(left: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xffF6F9FF),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),

              //  DottedLine(
              //   dashColor: Colors.grey,
              // ),
              SizedBox(height: MediaQuery.of(context).size.height * .016),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name',
                      style: GoogleFonts.inter(
                        color: grey,
                        fontSize: 10.px,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Date',
                      style: GoogleFonts.inter(
                        color: grey,
                        fontSize: 10.px,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              Padding(
                padding: EdgeInsets.only(left: 13, right: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Oyinola Agoro',
                      style: GoogleFonts.inter(
                        fontSize: 12.px,
                        color: blck,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.inter(
                        fontSize: 12.px,
                        color: blck,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Location',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w200,
                        fontSize: 10.px,
                        color: grey,
                      ),
                    ),
                    Text(
                      'Members',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w200,
                        fontSize: 10.px,
                        color: grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location,
                      style: GoogleFonts.inter(
                        fontSize: 13.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      members.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 13.px,
                        fontWeight: FontWeight.bold,
                        color: blck,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: mqh * .01),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: mqw * .872,
                  height: mqh * .043,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Color.fromRGBO(2, 91, 143, 0.1),
                  ),
                  child: Center(
                    child: Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 10.px,
                        fontWeight: FontWeight.w400,
                        foreground:
                            Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 0, 146, 1),
                                  Color.fromRGBO(132, 60, 205, 1),
                                  Color.fromRGBO(33, 109, 253, 1),
                                ],
                              ).createShader(
                                const Rect.fromLTWH(0, 0, 200, 100),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
    : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 7.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
