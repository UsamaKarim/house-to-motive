import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  // DateTime _selectedDay = DateTime.now();
  // void _onDaySelected(DateTime day,DateTime focusedDay){
  //   setState(() {
  //     _selectedDay = day;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F9FF),
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
          'My Date',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(onPressed: (){}, child: Text(
        'Invite',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          ),)
          )
        ]
      ),
      body: Center(child:   Text(
        'Coming Soon...',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),)
      // Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       TableCalendar(
      //         firstDay: DateTime.utc(2010, 10, 16),
      //         lastDay: DateTime.utc(2030, 3, 14),
      //         focusedDay: _selectedDay,
      //         calendarStyle: const CalendarStyle(
      //           defaultTextStyle: TextStyle(
      //             color: Color(0xff7390A1),
      //           ),
      //         ),
      //         daysOfWeekStyle: DaysOfWeekStyle(
      //           weekdayStyle: GoogleFonts.inter(
      //             fontSize: 13,
      //             fontWeight: FontWeight.w700,
      //             color: Color(0xff025B8F),
      //           ),
      //           weekendStyle: GoogleFonts.inter(
      //             fontSize: 13,
      //             fontWeight: FontWeight.w700,
      //             color: Color(0xff025B8F),
      //           ),
      //         ),
      //         headerStyle: HeaderStyle(
      //           rightChevronIcon: Row(
      //             children: [
      //               Icon(
      //                 Icons.arrow_back_ios,
      //                 size: 15,
      //               ),
      //               SizedBox(width: 10.w),
      //               Icon(
      //                 Icons.arrow_forward_ios,
      //                 size: 15,
      //               ),
      //             ],
      //           ),
      //           formatButtonVisible: false,
      //           titleTextStyle: GoogleFonts.inter(
      //             color: Colors.black,
      //             fontSize: 16,
      //             fontWeight: FontWeight.w100,
      //           ),
      //         ),
      //         selectedDayPredicate: (day)
      //           => isSameDay(_selectedDay, day),
      //         onDaySelected: _onDaySelected
      //       ),
      //       SizedBox(height: 2.h,),
      //       Text(""+ _selectedDay.toString().split(" ")[0]),
      //       Expanded(
      //         child: ListView.builder(
      //           itemCount: 3,
      //           itemBuilder: (context, index) {
      //
      //             return CalenderCard(
      //               context,
      //               CalenderName[index],
      //               CalenderDate1[index],
      //               CalenderDate2[index],
      //             );
      //         },
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}