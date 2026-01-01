import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  const CustomButton({super.key, required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.060,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xff025B8F),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
            fontFamily: 'ProximaNova',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,),
          ),
        ),
      ),
    );
  }
}
