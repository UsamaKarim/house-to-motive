import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PaymentMethodProcess extends StatefulWidget {
  const PaymentMethodProcess({Key? key}) : super(key: key);

  @override
  State<PaymentMethodProcess> createState() => _PaymentMethodProcessState();
}

class _PaymentMethodProcessState extends State<PaymentMethodProcess> {
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  Color buttonColor = Color(0xffF6F9FF);
  Color textColor = Color(0xff7390A1);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF6F9FF),
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0XFF025B8F),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.white,
                size: 16,
              ),
            ),
            Text(
              "Add New Card",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 40, width: 40),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height / 40),
            SvgPicture.asset("assets/Credit card.svg", fit: BoxFit.fill),
            SizedBox(height: size.height / 40),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 19,
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: cardHolderController,
                    onChanged: (text) {
                      // Check if any of the text fields is not empty to change the button color
                      if (text.isNotEmpty ||
                          cardNumberController.text.isNotEmpty ||
                          expDateController.text.isNotEmpty ||
                          cvvController.text.isNotEmpty) {
                        setState(() {
                          buttonColor = Color(0xff025BBF);
                        });
                      } else {
                        setState(() {
                          buttonColor = Color(0xffF6F9FF);
                        });
                      }
                    },
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xffD9D9D9)),
                      ),
                      hintText: "Card holder name",
                      hintStyle: TextStyle(fontSize: 14, color: textColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 40),
                  TextFormField(
                    controller: cardNumberController,
                    onChanged: (text) {
                      if (text.isNotEmpty ||
                          cardHolderController.text.isNotEmpty ||
                          expDateController.text.isNotEmpty ||
                          cvvController.text.isNotEmpty) {
                        setState(() {
                          buttonColor = Color(0xff025BBF);
                        });
                      } else {
                        setState(() {
                          buttonColor = Color(0xffF6F9FF);
                        });
                      }
                    },
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xffD9D9D9)),
                      ),
                      hintText: "Card number / iban",
                      hintStyle: TextStyle(fontSize: 14, color: textColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 40),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            TextFormField(
                              controller: expDateController,
                              onChanged: (text) {
                                if (text.isNotEmpty ||
                                    cardHolderController.text.isNotEmpty ||
                                    cardNumberController.text.isNotEmpty ||
                                    cvvController.text.isNotEmpty) {
                                  setState(() {
                                    buttonColor = Color(0xff025BBF);
                                  });
                                } else {
                                  setState(() {
                                    buttonColor = Color(0xffF6F9FF);
                                  });
                                }
                              },
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Color(0xffD9D9D9),
                                  ),
                                ),
                                hintText: "Exp date.",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10), // Add spacing between the fields
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            TextFormField(
                              controller: cvvController,
                              onChanged: (text) {
                                if (text.isNotEmpty ||
                                    cardHolderController.text.isNotEmpty ||
                                    cardNumberController.text.isNotEmpty ||
                                    expDateController.text.isNotEmpty) {
                                  setState(() {
                                    buttonColor = Color(0xff025BBF);
                                  });
                                } else {
                                  setState(() {
                                    buttonColor = Color(0xffF6F9FF);
                                  });
                                }
                              },
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Color(0xffD9D9D9),
                                  ),
                                ),
                                hintText: "CVV",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height / 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Color(0xff025BBF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      backgroundColor: buttonColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentMethodProcess(),
                        ),
                      );
                    },
                    child: Text(
                      "Add Card",
                      style: TextStyle(
                        color:
                            buttonColor == Color(0xff025BBF)
                                ? Colors.white
                                : Color(0xff025BBF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
