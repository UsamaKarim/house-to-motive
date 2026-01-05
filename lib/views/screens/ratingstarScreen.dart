import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ratingstarScreen extends StatefulWidget {
  const ratingstarScreen({Key? key}) : super(key: key);

  @override
  State<ratingstarScreen> createState() => _ratingstarScreenState();
}

class _ratingstarScreenState extends State<ratingstarScreen> {
  TextEditingController _textController = TextEditingController();
  int maxCharacters = 200;
  Color buttonColor = Colors.white; // Initial background color
  Color textColor = const Color(0XFF7390A1); // Initial text color

  RxBool keyboardVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    keyboardVisible.value = MediaQuery.of(context).viewInsets.bottom != 0;
    log(keyboardVisible.value.toString());
    final Size size = MediaQuery.of(context).size;
    return Obx(
      () => SingleChildScrollView(
        child: SizedBox(
          height:
              keyboardVisible.value ? size.height / 1.22 : size.height / 1.65,
          child: Column(
            children: [
              SizedBox(height: size.height / 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Rate your experience",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset("assets/Cross icon.svg"),
                  ),
                ],
              ),
              // SizedBox(
              //   height: size.height / 50,
              // ),
              Align(
                alignment: Alignment.centerLeft,
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              // SizedBox(
              //   height: size.height / 50,
              // ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Rate your experience",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please share your opinion about your experience",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 40,
              ),
              TextFormField(
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom * 2),
                controller: _textController,
                maxLines: 5,
                maxLength: maxCharacters,
                onChanged: (text) {
                  setState(() {
                    // Set background color and text color based on whether there is text entered or not
                    buttonColor = text.isNotEmpty
                        ? const Color(0XFF025B8F)
                        : Colors.white;
                    textColor = text.isNotEmpty
                        ? Colors.white
                        : const Color(0XFF7390A1);
                  });
                },
                decoration: InputDecoration(
                  hintText: "Your review",
                  hintStyle: TextStyle(fontSize: 12, color: textColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  counterText: "${_textController.text.length}/$maxCharacters",
                ),
              ),
              SizedBox(
                height: size.height / 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedSize: const Size(300, 50),
                  backgroundColor: buttonColor,
                ),
                onPressed: () {
                  // _showBottomSheetSlider(context);
                },
                child: Text("Rate it", style: TextStyle(color: textColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
