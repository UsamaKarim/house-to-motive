import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/controller/get_video_controller.dart';

import 'package:house_to_motive/utils/utils.dart';
import 'package:house_to_motive/utils/zegocalls/login_services.dart';
import 'package:house_to_motive/views/login/loginwith_email.dart';
import 'package:house_to_motive/views/screens/edit_profile_screen.dart';
import 'package:house_to_motive/views/screens/following_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/event_controller.dart';
import '../Calender/MyCalander.dart';
import '../Favourites/newFav.dart';
import 'Ticket.dart';
import '../../widgets/appbar_location.dart';
import '../../widgets/loginbutton.dart';
import '../../widgets/profile_widget.dart';
import 'contactus_screen.dart';
import 'create_event.dart';
import 'followers_screen.dart';

String? profilePicUrl;
Map<String, dynamic>? data;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TicketController ticketController = Get.put(TicketController());

  var isGuestLogin;
  bool showLoader = true;

  void _shareContent() {
    Share.share('house_to_motive');
  }

  Future<DocumentSnapshot> getUserDetails(String userId) async {
    return FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      var userDocument =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser?.uid)
              .get();

      return userDocument.data();
    } catch (e) {
      log("Error fetching user data: $e");
      return null;
    }
  }

  RxString currentUserUid = "".obs;
  // @override
  // void initState() {
  //   super.initState();
  //     currentUserUid.value = FirebaseAuth.instance.currentUser?.uid??"";
  //     ticketController.fetchFollowingList(currentUserUid.value);
  //     ticketController.fetchFollowersList(currentUserUid.value);
  // }

  @override
  void initState() {
    super.initState();
    _checkGuestMode(); // Call the async method to update isGuestLogin
  }

  _checkGuestMode() async {
    bool guestStatus = await checkGuestMode(); // Await the async method
    setState(() {
      isGuestLogin = guestStatus;
      showLoader =
          false; // Update the state when the async operation is complete
    });

    if (!isGuestLogin) {
      currentUserUid.value = FirebaseAuth.instance.currentUser?.uid ?? "";
      ticketController.fetchFollowingList(currentUserUid.value);
      ticketController.fetchFollowersList(currentUserUid.value);
    }
  }

  Future<bool> checkGuestMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool('isGuest') ?? false;
    return result; // Return bool, defaulting to false if no value
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final GetVideoController getVideoController = Get.put(GetVideoController());
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              !showLoader
                  ? isGuestLogin
                      ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Please Login to continue',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            CustomButton(
                              title: "Login",
                              ontap: () {
                                Get.offAll(() => LoginWithEmailScreen());
                              },
                            ),
                          ],
                        ),
                      )
                      : Column(
                        children: [
                          Container(
                            height: Get.height / 5,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            FutureBuilder(
                                              future: fetchUserData(),
                                              builder: (
                                                BuildContext context,
                                                AsyncSnapshot<
                                                  Map<String, dynamic>?
                                                >
                                                snapshot,
                                              ) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade100,
                                                    child: const CircleAvatar(
                                                      radius: 35,
                                                      backgroundColor:
                                                          Colors.white,
                                                      // backgroundImage: AssetImage('assets/pngs/user_profile.png'),
                                                    ),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                    "Error: ${snapshot.error}",
                                                  );
                                                } else if (snapshot.hasData) {
                                                  profilePicUrl =
                                                      snapshot
                                                          .data?['profilePic'];
                                                  return profilePicUrl != null
                                                      ? CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Colors.black,
                                                        backgroundImage: NetworkImage(
                                                          profilePicUrl!
                                                                  .isNotEmpty
                                                              ? profilePicUrl!
                                                              : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                                          scale: 1.0,
                                                        ),
                                                      )
                                                      : const CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage: AssetImage(
                                                          'assets/pngs/user_profile.png',
                                                        ),
                                                      );
                                                } else {
                                                  return const Text(
                                                    "No user data available",
                                                  );
                                                }
                                              },
                                            ),
                                            SizedBox(height: 1.h),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: getUserDetails(
                                                auth.currentUser?.uid ?? "",
                                              ),
                                              builder: (
                                                BuildContext context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                snapshot,
                                              ) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text(
                                                    "User not found",
                                                  );
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  data =
                                                      snapshot.data?.data()
                                                          as Map<
                                                            String,
                                                            dynamic
                                                          >;
                                                  return Text(
                                                    data!['User Name']
                                                                .toString()
                                                                .length <
                                                            8
                                                        ? data!['User Name']
                                                            .toString()
                                                        : '${data!['User Name'].toString().substring(0, 6)}...',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  );
                                                }
                                                return const Text("Loading...");
                                              },
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => const FollowersScreen(),
                                            );
                                          },
                                          child: SizedBox(
                                            height: 80,
                                            width: 80,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Followers',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(
                                                      0xff7390A1,
                                                    ),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Text(
                                                    ticketController
                                                        .followersList
                                                        .length
                                                        .toString(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                        0xff025B8F,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => const FollowingScreen(),
                                            );
                                          },
                                          child: SizedBox(
                                            height: 80,
                                            width: 80,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Following',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(
                                                      0xff7390A1,
                                                    ),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Text(
                                                    ticketController
                                                        .followingList
                                                        .length
                                                        .toString(),
                                                    // followingLength,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                        0xff025B8F,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'Posts',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(
                                                    0xff7390A1,
                                                  ),
                                                ),
                                              ),
                                              Obx(
                                                () => Text(
                                                  '${getVideoController.userVideos.length}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                      0xff025B8F,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.only(left: 10.0),
                                //       child: Text(
                                //         'Business man',
                                //         style: GoogleFonts.inter(
                                //           fontSize: 10,
                                //           fontWeight: FontWeight.w400,
                                //           color: const Color(0xff7390A1),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          // ProfileWidget(),
                          Container(
                            // height: 50,
                            // width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 0.7.h),
                                ProfileWidget(
                                  svg: 'assets/svgs/userr.svg',
                                  title: 'Edit Profile',
                                  onTap: () {
                                    Get.to(() => const EditProfileScreen());
                                  },
                                ),
                                ProfileWidget(
                                  svg: 'assets/svgs/Ticket 22.svg',
                                  title: 'My Tickets',
                                  onTap: () {
                                    Get.to(() => const ticketScreens());
                                    // Get.to(() =>  UserProfileScreen());
                                  },
                                ),
                                ProfileWidget(
                                  svg: 'assets/svgs/Heart 1.svg',
                                  title: "Favourites",
                                  onTap: () {
                                    Get.to(() => const FavList());
                                  },
                                ),
                                ProfileWidget(
                                  svg: 'assets/svgs/calendar1.svg',
                                  title: 'My Dates',
                                  onTap: () {
                                    Get.to(() => const CalenderScreen());
                                  },
                                ),
                                FirebaseAuth.instance.currentUser?.email ==
                                        "sales@housetomotive.com"
                                    ? ProfileWidget(
                                      svg:
                                          'assets/svgs/carbon_intent-request-create.svg',
                                      title: 'Create Event',
                                      onTap: () {
                                        Get.to(() => CreateEventScreen());
                                      },
                                    )
                                    : const SizedBox.shrink(),
                                // ProfileWidget(
                                //     svg: 'assets/svgs/Play Circle.svg',
                                //     title: 'Create Reel',
                                //     isDevider: false,
                                //     onTap: () {}),
                                // SizedBox(height: 0.7.h),
                              ],
                            ),
                          ),
                          // SizedBox(height: 2.h),
                          // Container(
                          //   // height: 50,
                          //   // width: Get.width,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //     color: Colors.white,
                          //   ),
                          //
                          //   child: Column(
                          //     children: [
                          //       SizedBox(height: 0.7.h),
                          //       ProfileWidget(
                          //           svg: 'assets/svgs/faqs.svg',
                          //           title: 'FAQs',
                          //           onTap: () {
                          //             Get.to(() => const FAQSScreen());
                          //           }),
                          //       ProfileWidget(
                          //           svg: 'assets/svgs/Settings.svg',
                          //           title: 'Settings',
                          //           onTap: () {
                          //             // Get.to(() =>  SettingScreen());
                          //             // Get.to(() =>  VideoListScreen());
                          //             Get.to(() => const SettingScreen());
                          //           }),
                          //       ProfileWidget(
                          //           svg: 'assets/svgs/privacy.svg',
                          //           title: "Privacy Policy",
                          //           onTap: () {
                          //             Get.to(() => const PrivacyPolicyScreen());
                          //           }),
                          //       ProfileWidget(
                          //           svg: 'assets/svgs/ph_share-fill.svg',
                          //           title: 'Invite People',
                          //           isDevider: false,
                          //           onTap: () {
                          //             _shareContent();
                          //           }),
                          //       SizedBox(height: 0.7.h),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 2.h),
                          Container(
                            // height: 50,
                            // width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),

                            child: Column(
                              children: [
                                SizedBox(height: 0.7.h),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.bottomSheet(
                                          const BottomSheetDeleteDialog(),
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color(0xff025B8F),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/delete.png',
                                                    color: Colors.white,
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: Get.width * 0.75,
                                                height: 35,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Delete Account',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Color(
                                                        0xff3C3C434D,
                                                      ),
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            indent: 65,
                                            color: Colors.black38,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // ProfileWidget(
                                //     svg: 'assets/delete.png',
                                //     title: 'Delete Account',
                                //     onTap: () {
                                //       Get.bottomSheet(const BottomSheetDeleteDialog());
                                //       // Get.to(() => const MapsScreen());
                                //     }),
                                ProfileWidget(
                                  svg: 'assets/svgs/contact.svg',
                                  title: 'Contact Us',
                                  onTap: () {
                                    Get.to(() => const ContactUSScreen());
                                    // Get.to(() => const MapsScreen());
                                  },
                                ),
                                ProfileWidget(
                                  svg: 'assets/svgs/Sign Outt.svg',
                                  onTap: () {
                                    Get.bottomSheet(
                                      const BottomSheetLogoutDialog(),
                                    );
                                  },
                                  title: 'Log Out',
                                  isDevider: false,
                                  red: true,
                                ),
                                const SizedBox(height: 0.7),
                              ],
                            ),
                          ),
                          SizedBox(height: 9.h),
                        ],
                      )
                  : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class BottomSheetLogoutDialog extends StatelessWidget {
  const BottomSheetLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Set the background color to transparent
      child: Container(
        height: Get.height / 2.4,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svgs/Sign Out.svg'),
              SizedBox(height: 1.7.h),
              Text(
                'Log Out',
                style: GoogleFonts.inter(
                  color: const Color(0xff010101),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.7.h),
              Text(
                textAlign: TextAlign.center,
                'Are you sure you want to logout from HouseToMotive?',
                style: GoogleFonts.inter(
                  color: const Color(0xff424B5A),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 2.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 5.5.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff090808)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xff090808),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 5.5.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xff025B8F),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(() => HomePage());
                        _signOut();
                      },
                      child: Center(
                        child: Text(
                          'Logout',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
    );
  }
}

void _signOut() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseAuth.instance
      .signOut()
      .then((value) {
        logout();
        prefs.setBool('isLogin', false);
        prefs.clear();
        Get.offAll(() => LoginWithEmailScreen());
        Utils().ToastMessage('Sign Out');
      })
      .onError((error, stackTrace) {
        Utils().ToastMessage(error.toString());
      });
  FirebaseAuth.instance.currentUser;
}

class BottomSheetDeleteDialog extends StatelessWidget {
  const BottomSheetDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Set the background color to transparent
      child: Container(
        height: Get.height / 2.4,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svgs/Sign Out.svg'),
              SizedBox(height: 1.7.h),
              Text(
                'Delete Account',
                style: GoogleFonts.inter(
                  color: const Color(0xff010101),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.7.h),
              Text(
                textAlign: TextAlign.center,
                'Are you sure you want to delete your account from HouseToMotive?',
                style: GoogleFonts.inter(
                  color: const Color(0xff424B5A),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 2.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 5.5.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff090808)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xff090808),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 5.5.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(() => HomePage());
                        deleteAccount();
                      },
                      child: Center(
                        child: Text(
                          'Delete',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
    );
  }
}

Future<void> deleteAccount() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Get.dialog(
    Center(child: CircularProgressIndicator()),
    barrierDismissible: false,
  );

  try {
    // Get the current user
    User? user = auth.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Delete Firestore user document
      await firestore.collection('users').doc(userId).delete();

      // Delete user account from Firebase Auth
      await user.delete();

      log('User account and Firestore data deleted successfully.');
      Utils().ToastMessage('Account deleted successfully.');

      // Redirect to a welcome or login screen
      Get.offAll(() => LoginWithEmailScreen());
    } else {
      log('No user is currently logged in.');
      Get.back();
      Utils().ToastMessage('No user is logged in.');
    }
  } catch (e) {
    // Handle errors
    if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
      Get.back();
      log('The user must reauthenticate before account deletion.');
      Utils().ToastMessage('Please reauthenticate and try again.');
      // Optionally navigate to reauthentication flow
    } else {
      Get.back();
      log('Error deleting account: $e');
      Utils().ToastMessage('Failed to delete account. Please try again.');
    }
  }
}
