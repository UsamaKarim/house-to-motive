import 'package:flutter/material.dart';

Widget CalenderCard(
    BuildContext context, String name, String date1, String date2) {
  return Container(
    // height: 116.h,
    height: MediaQuery.of(context).size.height * 0.16,
    // width: 343.w,
    width: MediaQuery.of(context).size.width * 0.34,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.11,
              // width: 44.w,
              // height: 44.h,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xffeef0ff)),
              child: Center(
                child: Text(date1,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff025B8F))),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(date2,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff7390A1)))
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.003,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.08,
              child: Row(
                children: [
                  Image.asset(
                    "assets/assets2/images/img.png",
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: MediaQuery.of(context).size.height * 0.81,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          )),
                      Text("60 Park LaneBOLTONBL26 1HQ",
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff716E90)))
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.24,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.009,
                      height: MediaQuery.of(context).size.height * 0.04,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xfffbd22f), Color(0xffc89f00)],
                      )))
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}
