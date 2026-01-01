import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/views/screens/create_event3.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controller/event_controller.dart';
import 'explore_screen.dart';

class CreateEvent2Screen extends StatefulWidget {
  const CreateEvent2Screen({super.key});

  @override
  State<CreateEvent2Screen> createState() => _CreateEvent2ScreenState();
}

class _CreateEvent2ScreenState extends State<CreateEvent2Screen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final TicketController ticketController = Get.put(TicketController());
    final placeApiController = Get.put(PlacesApi());
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
            'Create Event 2',
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
                  'Date',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    color: const Color(0xff025B8F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
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
                        Text(
                          ticketController
                              .getSelectedDay()
                              .toString()
                              .split(" ")[0],
                          style: const TextStyle(
                            fontFamily: 'ProximaNova',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff090808),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => CustomDialog(),
                            );
                          },
                          child: SvgPicture.asset('assets/svgs/calendar.svg'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text(
                      'Start',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        color: const Color(0xff025B8F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 2.7),
                    Text(
                      'End',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        color: const Color(0xff025B8F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                              Text(
                                ticketController.selectedTime.value
                                    .format(context),
                                style: const TextStyle(
                                  fontFamily: 'ProximaNova',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff090808),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ticketController.selectTime(context);
                                },
                                child: SvgPicture.asset('assets/svgs/time.svg'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Container(
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
                              Text(
                                ticketController.selectedTimeEnd.value
                                    .format(context),
                                style: const TextStyle(
                                  fontFamily: 'ProximaNova',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff090808),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ticketController.selectTimeEnd(context);
                                },
                                child: SvgPicture.asset('assets/svgs/time.svg'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Location',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    color: const Color(0xff025B8F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return placeApiController
                        .getSuggestions(textEditingValue.text);
                  },
                  onSelected: (String selection) {
                    placeApiController.searchPlaces(selection);
                    ticketController.locationController.text = selection;
                  },
                  fieldViewBuilder: (BuildContext context,
                      eventLocationController,
                      fieldFocusNode,
                      onFieldSubmitted) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            // controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            controller: eventLocationController,
                            decoration:  InputDecoration(
                              border: OutlineInputBorder(borderSide: const BorderSide(color:Colors.black12),
                                  borderRadius: BorderRadius.circular(20.px),
                              ),
                                isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h)
                            ),
                          ),
                        ),
                        SizedBox(width: 1.h),
                        Container(
                          height: 6.h,
                          width: 6.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black12),
                            // color: Colors.red,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                                'assets/svgs/teenyicons_location-solid.svg'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 2.h),
                ListTile(
                  dense: true,
                  title: Text(
                    'Make this event private',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff090808),
                    ),
                  ),
                  trailing: Switch(
                    activeTrackColor: Colors.green,
                    value: ticketController.isPrivate.value,
                    onChanged: (bool value) {
                      ticketController.togglePrivate(value);
                    },
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    'Disable Comments',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff090808),
                    ),
                  ),
                  trailing: Switch(
                    activeTrackColor: Colors.green,
                    value: ticketController.isCommentDisable.value,
                    onChanged: (bool value) {
                      ticketController.isCommentDisable(value);
                    },
                  ),
                ),
                // const Spacer(),
                SizedBox(height: 26.h),
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
                          Get.to(() => CreateEvent3Screen());
                          // controller.event2(controller.locationController.text);
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
                                  color: Colors.white),
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

//
class CustomDialog extends StatelessWidget {
  final TicketController ticketController = Get.put(TicketController());

  CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 52.h,
        child: Obx(
          () => TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: ticketController.selectedDay.value,
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(
                color: Color(0xff7390A1),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xff025B8F),
              ),
              weekendStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xff025B8F),
              ),
            ),
            headerStyle: HeaderStyle(
              rightChevronIcon: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    size: 15,
                  ),
                  SizedBox(width: 10.w),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ],
              ),
              formatButtonVisible: false,
              titleTextStyle: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w100,
              ),
            ),
            selectedDayPredicate: (day) =>
                isSameDay(ticketController.selectedDay.value, day),
            onDaySelected: ticketController.onDaySelected,
          ),
        ),
      ),
    );
  }
}
