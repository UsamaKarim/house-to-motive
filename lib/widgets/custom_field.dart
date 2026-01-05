import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_to_motive/views/login/forgot_password.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

//
class CustomPasswordField extends StatelessWidget {
  final String title;
  final TextEditingController? textEditingController;
  const CustomPasswordField(
      {super.key, required this.title, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        controller: textEditingController,
        obscureText: true,
        validator: (CurrentValue) {
          var nonNullValue = CurrentValue ?? '';
          if (nonNullValue.isEmpty) {
            return ("password is required");
          }
          if (!nonNullValue.contains("@")) {
            return ("password should contains @");
          }
          return null;
        },
        decoration: InputDecoration(
            hintText: title,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Color(0xffD9D9D9),
              ),
            ),
            hintStyle: TextStyle(
              fontFamily: 'ProximaNova',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff7390A1),
            ),
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Color(0xffD9D9D9),
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                Get.to(() => ForgotPasswordScreen());
              },
              child: Padding(
                padding: EdgeInsets.only(top: 15.px, right: 6.px),
                child: Text(
                  'Forgot ?',
                  style: TextStyle(
                    fontFamily: 'ProximaNova',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class CustomEmailField extends StatelessWidget {
  final String title;
  final TextEditingController? textEditingController;
  RxBool showTick = false.obs;
  CustomEmailField({
    super.key,
    required this.title,
    this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(
              fontFamily: 'ProximaNova',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff7390A1),
            ),
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Color(0xffD9D9D9),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Color(0xffD9D9D9),
              ),
            ),
            // Display an icon based on the condition
            suffixIcon: showTick.value
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : null,
          ),
          validator: (value) {
            // Define a regular expression for email validation
            RegExp regex = RegExp(
              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
            );

            // Check if the entered email is valid
            if (value == null || value.isEmpty) {
              return 'Email is required';
            } else if (!regex.hasMatch(value)) {
              return 'Enter a valid email address';
            } else {
              return null; // Return null if the email is valid
            }
          },
          onChanged: (value) {
            // Update the showTick variable based on email validity
            showTick.value = textEditingController!.text.isNotEmpty &&
                RegExp(
                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                ).hasMatch(textEditingController!.text);
          },
        ),
      ),
    );
  }
}
