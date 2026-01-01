import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonWidget extends StatefulWidget {
  ButtonWidget({super.key});

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  RxBool isSelectedContainer1 = true.obs; // Set this to true for default selection
  RxBool isSelectedContainer2 = false.obs;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              isSelectedContainer1.toggle();
              isSelectedContainer2.value = !isSelectedContainer1.value;
            },
            child: Obx(
                  () => Container(
                height: screenHeight * 0.07,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  color: isSelectedContainer1.isTrue
                      ? const Color(0xff025B8F)
                      : Colors.white,
                ),
                child: Center(
                  child: isSelectedContainer1.isTrue
                      ? Image.asset('assets/svgs/home/🎉 Things to Do.png')
                      : Image.asset('assets/svgs/home/🎉 Things to Do2.png'),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              isSelectedContainer2.toggle();
              isSelectedContainer1.value = !isSelectedContainer2.value;
            },
            child: Obx(
                  () => Container(
                    height: screenHeight * 0.07,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: isSelectedContainer2.isTrue
                      ? const Color(0xff025B8F)
                      : Colors.white,
                ),
                child: Center(
                  child: isSelectedContainer2.isTrue
                      ? Image.asset('assets/svgs/home/🗓️ Events Near Me2.png')
                      : Image.asset('assets/svgs/home/🗓️ Events Near Me.png'),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
