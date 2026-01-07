import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileWidget extends StatelessWidget {
  final bool isDevider;
  final bool red;
  final String title;
  final VoidCallback? onTap;
  final String svg;
  const ProfileWidget({
    super.key,
    required this.title,
    this.isDevider = true,
    this.red = false,
    required this.onTap,
    required this.svg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: red ? Colors.red : Color(0xff025B8F),
                    ),
                    child: Center(child: SvgPicture.asset(svg)),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: Get.width * 0.75,
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff3C3C434D),
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              isDevider
                  ? Divider(indent: 65, color: Colors.black38)
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
