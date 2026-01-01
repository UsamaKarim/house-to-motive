import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final String svg;
  final String title;
  final VoidCallback ontap;
  const CustomButtonWithIcon(
      {super.key, required this.svg, required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.060,
        width:MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xff025B8F),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(svg,height: 22),
                SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'ProximaNova',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSocialButton extends StatelessWidget {
  final String svg;
  final VoidCallback ontap;
  const CustomSocialButton({super.key, required this.svg, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.060,
        width: MediaQuery.of(context).size.width * 0.13,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(15),
          // color: Colors.black,
        ),
        child: Center(
          child: SvgPicture.asset(svg,height: 22),
        ),
      ),
    );
  }
}
