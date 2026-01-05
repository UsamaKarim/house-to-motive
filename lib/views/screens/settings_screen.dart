import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'changePassword.dart';
import 'followers_screen.dart';
import '../../widgets/profile_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool light0 = true.obs;
    RxBool light1 = true.obs;
    RxBool light2 = false.obs;
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
          'Settings',
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
          children: [
            Container(
              // height: 50,
              // width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),

              child: Column(
                children: [
                  SizedBox(height: 0.7.h),
                  // ProfileWidget(title: 'App Language', onTap: () {
                  //
                  // }),
                  SettingWidget(
                    title: 'App Language',
                    onTap: () {},
                  ),
                  SettingWidget(
                    title: 'App Info',
                    onTap: () {},
                  ),
                  SettingWidget(
                    title: 'Change Password',
                    onTap: () {
                      Get.to(() => ChangePassWordScreen());
                    },
                  ),
                  SettingWidget(
                    title: 'Invite Friends',
                    onTap: () {},
                  ),

                  SizedBox(height: 0.7.h),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              // height: 50,
              // width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),

              child: Column(
                children: [
                  // SizedBox(height: 0.7.h),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Invitation',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              // const Spacer(),
                              Obx(
                                () => Switch(
                                  activeTrackColor: Colors.green,
                                  value: light0.value,
                                  onChanged: (bool value) {
                                    light0.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Divider(
                              // indent: 65,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Invitation',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              // const Spacer(),
                              Obx(
                                () => Switch(
                                  activeTrackColor: Colors.green,
                                  value: light1.value,
                                  onChanged: (bool value) {
                                    light1.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Divider(
                              // indent: 65,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Invitation',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              // const Spacer(),
                              Obx(
                                () => Switch(
                                  activeTrackColor: Colors.green,
                                  value: light2.value,
                                  onChanged: (bool value) {
                                    light2.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Divider(
                              // indent: 65,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 0.1.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  SettingWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 0.5.h),
        GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
              SizedBox(height: 0.5.h),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Divider(
                  color: Colors.black38,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
