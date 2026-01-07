import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/event_controller.dart';
import 'create_event2.dart';

class CreateEventScreen extends StatelessWidget {
  CreateEventScreen({super.key});

  final ButtonController controller = Get.put(ButtonController());
  // final CollectionReference collectionReference =
  // FirebaseFirestore.instance.collection('tickets');
  //
  // void updateFieldInAllDocuments() async {
  //   QuerySnapshot querySnapshot = await collectionReference.get();
  //   querySnapshot.docs.forEach((doc) {
  //     collectionReference.doc(doc.id).update({
  //       'uid': '5CIJVbhQVpZ3oZbLjjl7LkOR1hB3', // Specify the field and its new value
  //     });
  //   });}
  @override
  Widget build(BuildContext context) {
    // updateFieldInAllDocuments();
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
            'Create Event',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ticket Details',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff025B8F),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        isSelected.value = true;
                        // if (isSelected.value == false) {
                        //   isSelected.value = true;
                        // }
                      },
                      child: Container(
                        height: 6.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          color:
                              isSelected.value
                                  ? const Color(0xff025B8F)
                                  : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            'Paid',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color:
                                  isSelected.value
                                      ? Colors.white
                                      : const Color(0xff025B8F),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // if (isSelected.value == true) {
                        //   isSelected.value = false;
                        // }
                        isSelected.value = false;
                      },
                      child: Container(
                        height: 6.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          color:
                              isSelected.value
                                  ? Colors.white
                                  : const Color(0xff025B8F),
                        ),
                        child: Center(
                          child: Text(
                            'Free',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color:
                                  isSelected.value
                                      ? const Color(0xff025B8F)
                                      : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'Max Participants',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff025B8F),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 6.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xff025B8F),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/mynaui_users-group.svg',
                              color: Colors.white,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              controller.count.value.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: () {
                        controller.increment();
                      },
                      child: CircleAvatar(
                        radius: 3.3.h,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svgs/+.svg',
                            color: const Color(0xff025B8F),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: () {
                        controller.decrement();
                      },
                      child: CircleAvatar(
                        radius: 3.3.h,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svgs/-.svg',
                            color: const Color(0xff025B8F),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // Text(
                //   'Add Ticket price',
                //   style: GoogleFonts.inter(
                //     fontSize: 17,
                //     fontWeight: FontWeight.w600,
                //     color: const Color(0xff025B8F),
                //   ),
                // ),
                // SizedBox(
                //   height: 2.h,
                // ),
                // TextFormField(
                //   controller: ticketController.eventPriceController,
                //   keyboardType: TextInputType.phone,
                //   decoration: InputDecoration(
                //     hintText: 'Enter price',
                //     hintStyle: const TextStyle(
                //       fontFamily: 'ProximaNova',
                //       fontSize: 14,
                //       fontWeight: FontWeight.w400,
                //       color: Color(0xff090808),
                //     ),
                //     isCollapsed: true,
                //     contentPadding:
                //         EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: const BorderSide(color: Colors.black12),
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //   ),
                // ),
                isSelected.value ? PaidContainer() : const FreeContainer(),
                // const Spacer(),
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
                        onTap: () {
                          Get.to(() => CreateEvent2Screen());
                        },
                        child: Container(
                          height: 5.5.h,
                          width: screenWidth / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff025B8F),
                          ),
                          child: Center(
                            child: Text(
                              'Next',
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

class FreeContainer extends StatelessWidget {
  const FreeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Customization for the Paid Container
      height: 44.h, // Adjust the height as needed
      width: double.infinity,
      // color: Colors.blue, // Customize the color
    );
  }
}

class PaidContainer extends StatelessWidget {
  PaidContainer({super.key});
  final TicketController ticketController = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.h),
        Container(
          height: 8.h,
          width: 17.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: const Color(0xffE45900),
          ),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              const Text(
                "Child",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: TextField(
                  controller: ticketController.childPriceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: '\$price',
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.white, fontSize: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.only(
                      bottom: 8,
                    ), // Adjust the padding as needed
                  ),
                  textAlign: TextAlign.center,
                  // cursorHeight: 15,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          height: 8.h,
          width: 17.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0XFF4ADE80), Color(0XFF256F40)],
            ),
            borderRadius: BorderRadius.circular(8.0),
            color: const Color(0xffE45900),
          ),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              const Text(
                "Adult",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 5),
              const SizedBox(height: 5),
              Expanded(
                child: TextField(
                  controller: ticketController.adultPriceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: '\$price',
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.white, fontSize: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    // contentPadding: EdgeInsets.only(bottom: 8), // Adjust the padding as needed
                  ),
                  textAlign: TextAlign.center,
                  // cursorHeight: 15,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          height: 8.h,
          width: 17.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0XFFFBD22F), Color(0XFFC89F00)],
            ),
            borderRadius: BorderRadius.circular(8.0),
            color: const Color(0xffE45900),
          ),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              const Text(
                "Family",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 5),
              const SizedBox(height: 5),
              Expanded(
                child: TextField(
                  controller: ticketController.familyPriceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: '\$price',
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.white, fontSize: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    // contentPadding: EdgeInsets.only(bottom: 8), // Adjust the padding as needed
                  ),
                  textAlign: TextAlign.center,
                  // cursorHeight: 15,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        // Text('Child'),
        // Text('Family'),
      ],
    );
  }
}

class ButtonController extends GetxController {
  var count = 0.obs;

  void increment() {
    count++;
  }

  void decrement() {
    if (count > 0) {
      count--;
    }
  }
}
