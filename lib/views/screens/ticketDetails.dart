
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'checkoutMethod.dart';

class ticketDetails extends StatefulWidget {
  final String title;
  final String ticketPrice;
   ticketDetails({Key? key,
  required this.title,required this.ticketPrice}) : super(key: key);

  @override
  State<ticketDetails> createState() => _ticketDetailsState();
}

class _ticketDetailsState extends State<ticketDetails> {
  final TextEditingController ticketPriceController=TextEditingController();
  RxInt price=1.obs;
  Rx<String> calculatedTicketPrice=''.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     calculatedTicketPrice.value=widget.ticketPrice;

  }
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0XFF025B8F),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [InkWell(onTap: () {
            Get.back();
          },
              child: const Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 16,)),

             Text(
             "${widget.title}",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(
              height: 40,
              width: 40,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 16),
          child: Column(children: [
            SizedBox(
              height: size.height / 40,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter Ticket Details",
                style: TextStyle(
                    color: Color(0XFF025B8F),
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: size.height / 40,
            ),
            TextFormField(
              decoration: InputDecoration(
                  isDense: true,
                  enabledBorder:
                      OutlineInputBorder(borderRadius:  BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  hintText: "User Name",
                  hintStyle: const TextStyle(fontSize: 14, color: Color(0xff7390A1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: size.height / 40,
            ),
            TextFormField(controller:ticketPriceController ,
              onChanged: (value) {

                if(value.isNotEmpty){
                  price.value= int.parse(value);

                  calculatedTicketPrice.value=(int.parse(widget.ticketPrice)*price.value).toString();

                }else{
                  calculatedTicketPrice.value=widget.ticketPrice;
                }

              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  isDense: true,
                  enabledBorder:
                  OutlineInputBorder(borderRadius:  BorderRadius.circular(20),

                      borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  hintText: "Total members",
                  hintStyle: const TextStyle(fontSize: 14, color: Color(0xff7390A1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: size.height / 40,
            ),
            TextFormField(
              decoration: InputDecoration(
                  isDense: true,
                  enabledBorder:
                  OutlineInputBorder(borderRadius:  BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                  hintText: "Enter email",
                  hintStyle: const TextStyle(fontSize: 14, color: Color(0xff7390A1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: size.height / 60,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "We will send QR code to this email.",
                style: TextStyle(
                    color: Color(0XFF7390A1),
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: size.height / 40,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.072,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (countryCode) {
                        print(countryCode.dialCode); // Prints the selected country code
                      },
                      initialSelection: 'US',
                      favorite: ['+1', 'US'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      textStyle: const TextStyle(color: Colors.black),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '0000 0000',
                          hintStyle: TextStyle(color: Color(0XFF7390A1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: size.height / 4,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Column(
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Color(0xffFF0092), Color(0xff216DFD)],
                      ).createShader(bounds);
                    },
                    child:  Obx(()=>
                       Text(
                        "£${calculatedTicketPrice.value}",
                        style:   TextStyle(
                            fontSize:price.value.toString().length>12?13:20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 80,
                  ),
                  const Text(
                    "Subtotal",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff707B81)),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedSize: const Size(160, 55),
                  backgroundColor: const Color(0xff025B8F),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> CheckoutMethod(
                    totalPrice: calculatedTicketPrice.value,
                  )));
                },
                child: const Text("Continue", style: TextStyle(color: Colors.white)),
              ),
            ],)

          ]),
        ),
      ),
    );
  }
}
