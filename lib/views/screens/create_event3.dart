import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/views/screens/navigation_bar/home_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/event_controller.dart';
import 'home_screens/home_model.dart';

class CreateEvent3Screen extends StatefulWidget {
  const CreateEvent3Screen({super.key});

  @override
  State<CreateEvent3Screen> createState() => _CreateEvent3ScreenState();
}

class _CreateEvent3ScreenState extends State<CreateEvent3Screen> {
  final TicketController ticketController = Get.put(TicketController());
  // final NotificationServices notificationServices = NotificationServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _deviceTokens = [];

  @override
  void initState() {
    super.initState();
    getAllDeviceTokens();
  }

  Future<void> getAllDeviceTokens() async {
    List<String> deviceTokens = [];

    try {
      CollectionReference users = _firestore.collection('users');

      QuerySnapshot querySnapshot = await users.get();

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('Device Token') &&
            data['Device Token'] is String) {
          deviceTokens.add(data['Device Token']);
        }
      }
      log('length: ${deviceTokens.length}');
      log('device Token: $deviceTokens');
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving device tokens: $e");
      }
    }

    setState(() {
      _deviceTokens = deviceTokens;
    });
  }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  // Future<List<String>> getAllDeviceTokens() async {
  //   List<String> deviceTokens = [];
  //
  //   try {
  //     CollectionReference users = _firestore.collection('users');
  //
  //     QuerySnapshot querySnapshot = await users.get();
  //
  //     for (var doc in querySnapshot.docs) {
  //       var data = doc.data() as Map<String, dynamic>;
  //       if (data.containsKey('Device Token') &&
  //           data['Device Token'] is String) {
  //         deviceTokens.add(data['Device Token']);
  //       }
  //     }
  //     log('length: ${deviceTokens.length}');
  //     log('device Token: ${deviceTokens}');
  //   } catch (e) {
  //     print("Error retrieving device tokens: $e");
  //   }
  //
  //   return deviceTokens;
  // }
  RxBool isLoading = false.obs;

  void uploadEvent() {
    if (ticketController.locationController.text.isEmpty) {
      Get.snackbar('Status', 'please enter a location');
    } else if (ticketController.eventNameController.text.isEmpty) {
      Get.snackbar('Status', 'please enter a Event name');
    } else if (ticketController.eventDescriptionController.text.isEmpty) {
      Get.snackbar('Status', 'please enter a Event Description');
    } else {
      isLoading.value = true;
      ticketController
          .uploadImageToFirebase(
            isPaid: isSelected.value,
            date: ticketController.getSelectedDay(),
            startTime: ticketController.selectedTime.value,
            endTime: ticketController.selectedTimeEnd.value,
            location: ticketController.locationController.text,
            eventName: ticketController.eventNameController.text,
            description: ticketController.eventDescriptionController.text,
            commentDisable: ticketController.isCommentDisable.value,
            private: ticketController.isPrivate.value,
            isEventFavourite: ticketController.isEventFavourite.value,
            // price: ticketController.eventPriceController,
            adultPriceController: ticketController.adultPriceController,
            childPriceController: ticketController.childPriceController,
            familyPriceController: ticketController.familyPriceController,
            uid: FirebaseAuth.instance.currentUser?.uid,
          )
          .then(
            (value) => {
              isLoading.value = false,

              // notificationServices.sendNotification(
              //     _deviceTokens,
              //     'Home to motive',
              //     'Event: ${ticketController.eventNameController.text}'),
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const BottomSheetEventDialog();
                },
              ),
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(
      () => Scaffold(
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
            'Create Event 3',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                Text(
                  'Event Name',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    color: const Color(0xff025B8F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: ticketController.eventNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter event name',
                    hintStyle: const TextStyle(
                      fontFamily: 'ProximaNova',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff090808),
                    ),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.h,
                      vertical: 1.5.h,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Description',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    color: const Color(0xff025B8F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: ticketController.eventDescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your event description',
                    hintStyle: const TextStyle(
                      fontFamily: 'ProximaNova',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff090808),
                    ),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.h,
                      vertical: 1.5.h,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Categories',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    color: const Color(0xff025B8F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                    // color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Art & Music',
                          style: TextStyle(
                            fontFamily: 'ProximaNova',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff090808),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset('assets/svgs/right.svg'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    ticketController.pickedImage();
                  },
                  child: Container(
                    height: 18.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12),
                      color: Colors.white,
                      image:
                          ticketController.selectedImage.value != null
                              ? DecorationImage(
                                image: FileImage(
                                  ticketController.selectedImage.value!,
                                ),
                                fit: BoxFit.cover,
                              )
                              : null,
                      // color: Colors.blue,
                    ),
                    child:
                        ticketController.selectedImage.value == null
                            ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/Document Upload 4.svg',
                                  ),
                                  SizedBox(width: 2.h),
                                  const GradientText(
                                    text: "Upload Photos",
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffFF0092),
                                        Color(0xff216DFD),
                                      ],
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'ProximaNova',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff424B5A),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : Container(),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 5.5.h,
                        width: screenWidth / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            'Save Draft',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          uploadEvent();
                          // getAllDeviceTokens();
                          // print('d token: $_deviceTokens');
                        },
                        child: Obx(
                          () =>
                              isLoading.value == true
                                  ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xff025B8F),
                                    ),
                                  )
                                  : Container(
                                    height: 5.5.h,
                                    width: screenWidth / 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xff025B8F),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Post',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSheetEventDialog extends StatelessWidget {
  const BottomSheetEventDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Set the background color to transparent
      child: Container(
        height: Get.height / 2.6,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svgs/Ticket 2.svg'),
              SizedBox(height: 1.7.h),
              Text(
                'Event Created Successfully !',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 1.7.h),
              Text(
                textAlign: TextAlign.center,
                'Waiting for the HouseToMotive to approve this event.',
                style: GoogleFonts.inter(
                  color: const Color(0xff424B5A),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                height: 5.5.h,
                width: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff025B8F),
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.offAll(() => HomePage());
                  },
                  child: Center(
                    child: Text(
                      'Go back to Home',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
