import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/color.dart';
import '../../../views/login/loginwith_email.dart';
import '../../../views/screens/notification_screen.dart';
import '../../../widgets/loginbutton.dart';

import 'FavEvents.dart';
import 'FavVideos.dart';
import 'myfavourite.dart';

class FavListController extends GetxController {
  RxBool isSelectedVideos = true.obs;
  RxBool isSelectedEvents = false.obs;
  RxBool isSelectedRestaurants = false.obs;

  void selectVideos() {
    isSelectedVideos.value = true;
    isSelectedEvents.value = false;
    isSelectedRestaurants.value = false;
  }

  void selectEvents() {
    isSelectedVideos.value = false;
    isSelectedEvents.value = true;
    isSelectedRestaurants.value = false;
  }

  void selectRestaurants() {
    isSelectedVideos.value = false;
    isSelectedEvents.value = false;
    isSelectedRestaurants.value = true;
  }
  // var tickets = <Ticket>[].obs;
  //
  // // Fetch tickets from Firestore
  // Future<void> fetchFavouriteTickets() async {
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  //   try {
  //     QuerySnapshot querySnapshot = await firestore.collection('tickets')
  //         .where('isEventFavourite', isEqualTo: true)
  //         .get();
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Map query results to a list of Ticket objects
  //       var ticketList = querySnapshot.docs.map((doc) {
  //         // Convert Firestore document to Ticket
  //         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //         return Ticket.fromMap(data);
  //       }).toList();
  //
  //       // Update the tickets list
  //       tickets.value = ticketList;
  //     } else {
  //       tickets.value = [];
  //       log('No favourite tickets found.');
  //     }
  //   } catch (e) {
  //     log('Error fetching tickets: $e');
  //   }
  // }

  var isGuestLogin = false;
  String userId = '';

  Future<bool> checkGuestMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool('isGuest') ?? false;
    return result; // Return bool, defaulting to false if no value
  }

  _checkGuestMode() async {
    bool guestStatus = await checkGuestMode(); // Await the async method
    if (!guestStatus) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _checkGuestMode();
  }
}

class FavList extends StatefulWidget {
  const FavList({super.key});

  @override
  State<FavList> createState() => _FavListState();
}

class _FavListState extends State<FavList> {
  final FavListController controller = Get.put(FavListController());

  int flag = 0;

  var isGuestLogin = false;

  Future<bool> checkGuestMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool('isGuest') ?? false;
    return result; // Return bool, defaulting to false if no value
  }

  _checkGuestMode() async {
    bool guestStatus = await checkGuestMode(); // Await the async method
    setState(() {
      isGuestLogin = guestStatus;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller. fetchFavouriteTickets();
    _checkGuestMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: const Text(
          'My Favourites',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          // GestureDetector(
          //     onTap: (){
          //       Get.to(() => FavList());
          //     },
          //     child: SvgPicture.asset('assets/appbar/heart.svg')),
          const SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Get.to(() => const NotificationScreen());
              },
              child: SvgPicture.asset('assets/appbar/Notification.svg')),
          const SizedBox(width: 10),
        ],
      ),
      body: isGuestLogin
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please Login to continue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    title: "Login",
                    ontap: () {
                      Get.offAll(() => LoginWithEmailScreen());
                    },
                  ),
                ),
              ],
            )
          : Padding(
              padding:
                  const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.selectVideos();
                              setState(() {
                                flag = 1;
                              });
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>FavVideos()));
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                borderRadius: controller.isSelectedVideos.value
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      )
                                    : const BorderRadius.only(
                                        topRight: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                color: controller.isSelectedVideos.value
                                    ? const Color(0xff025B8F)
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  "Videos",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: controller.isSelectedVideos.value
                                        ? Colors.white
                                        : seagreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.selectEvents();
                              setState(() {
                                flag = 2;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                borderRadius: controller.isSelectedVideos.value
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      )
                                    : const BorderRadius.only(
                                        topRight: Radius.circular(0),
                                        topLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(0)),
                                color: controller.isSelectedEvents.value
                                    ? const Color(0xff025B8F)
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  "Events",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: controller.isSelectedEvents.value
                                        ? Colors.white
                                        : seagreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.selectRestaurants();
                              setState(() {
                                flag = 3;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                borderRadius: controller.isSelectedVideos.value
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      )
                                    : const BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        bottomLeft: Radius.circular(0),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                color: controller.isSelectedRestaurants.value
                                    ? const Color(0xff025B8F)
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  "Restaurants",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        controller.isSelectedRestaurants.value
                                            ? Colors.white
                                            : seagreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  flag == 1
                      ? Expanded(
                          child: FavVideos(
                          userId: controller.userId,
                        ))
                      : flag == 2
                          ? Expanded(
                              child: FavEvents(),
                            )
                          : flag == 3
                              ? const Expanded(
                                  child: FavRestaurants(),
                                )
                              : Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: FavVideos(
                                      userId: controller.userId,
                                    ),
                                  ),
                                ),
                ],
              ),
            ),
    );
  }
}
