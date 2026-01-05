import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FAQSScreen extends StatelessWidget {
  const FAQSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RxBool> isExpandedList = List.generate(10, (index) => false.obs);

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
          'FAQs',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        trailing: Icon(
                          isExpandedList[index].value
                              ? Icons.remove
                              : Icons.add,
                          color: Color(0xff025B8F),
                        ),
                        childrenPadding: EdgeInsets.symmetric(vertical: 4),
                        title: Text(
                          'Lorem ipsum dolor sit amet, consectetur.',
                          style: TextStyle(
                            fontFamily: 'ProximaNova',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff7390A1),
                          ),
                        ),
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Column(
                                  children: [
                                    MySeparator(),
                                    SizedBox(height: 1.h),
                                    Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                                      style: TextStyle(
                                        fontFamily: 'ProximaNova',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff7390A1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        onExpansionChanged: (bool expanded) {
                          isExpandedList[index].value = expanded;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({
    Key? key,
    this.height = 1,
  }) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xffE0E0E0)),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
