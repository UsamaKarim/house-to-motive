import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_to_motive/controller/getchat_controller.dart';
import '../../../controller/get_video_controller.dart';
import '../explore_screen.dart';
import '../chat_screen.dart';
import '../home_screens/home_screen.dart';
import '../profile_screen.dart';
import '../search.dart';
import 'color.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  final bool? status;
  final int? selectedIndex;
  final String? searchQuery;

  const HomePage({
    super.key,
    this.selectedIndex,
    this.searchQuery,
    this.status,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetChatSController getChatSController = Get.put(GetChatSController());

  final GetVideoController getVideoController = Get.put(GetVideoController());

  final placeApiController = Get.put(PlacesApi());
  List<String> selectedSvg = [
    'assets/selected/Home Filled.svg',
    'assets/selected/Explore Filled.svg',
    'assets/selected/Search Filled.svg',
    'assets/selected/My Chat Filled.svg',
    'assets/selected/My Profile.svg',
  ];
  List<String> unSelectedSvg = [
    'assets/unselected/Home.svg',
    'assets/unselected/Explore.svg',
    'assets/unselected/Search.svg',
    'assets/unselected/My Chat.svg',
    'assets/unselected/My Profile.svg',
  ];
  RxInt currentIndex = 0.obs;
  int selectBtn = 0;
  bool status = false;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    // getVideoController.fetchAndMarkLocations().then((value) => {
    //       getVideoController.checkNearbyVideos().then((value) {
    //         placeApiController.determinePosition();
    //         if (widget.selectedIndex != null) {
    //           currentIndex = widget.selectedIndex!.obs;
    //         }
    //       })
    //     });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Obx(
      () => // Wrap with Obx
          Container(
        color: bgColor,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (currentIndex.value == 0) const HomeScreen(),
                  if (currentIndex.value == 1)
                    ExploreScreen(
                      selectedLocation: widget.searchQuery,
                      markers: _markers,
                    ),
                  if (currentIndex.value == 2) const SearchScreen(),
                  if (currentIndex.value == 3) const ChatScreen(),
                  if (currentIndex.value == 4) const ProfileScreen(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: MyCustomClipper(currentIndex),
                      child: Container(
                        height: height * 0.09,
                        width: double.infinity,
                        color: Colors.white,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            left: width * 0.06,
                            top: height * 0.02,
                            right: width * 0.06,
                          ),
                          shrinkWrap: true,
                          itemCount: selectedSvg.length,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    currentIndex.value = index;
                                    // widget.searchQuery = null;
                                  },
                                  child:
                                      currentIndex.value == index
                                          ? SvgPicture.asset(selectedSvg[index])
                                          : SvgPicture.asset(
                                            unSelectedSvg[index],
                                          ),
                                ),
                                SizedBox(
                                  width:
                                      index == 3
                                          ? width * 0.09
                                          : index == 2
                                          ? width * 0.09
                                          : width * 0.11,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: height * 0.08,
                    left:
                        currentIndex.value == 0
                            ? width * 0.085
                            : currentIndex.value == 1
                            ? width * 0.28
                            : currentIndex.value == 2
                            ? width * 0.475
                            : currentIndex.value == 3
                            ? width * 0.665
                            : currentIndex.value == 4
                            ? width * 0.86
                            : 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xff025B8F),
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

class MyCustomClipper extends CustomClipper<Path> {
  RxInt currentIndex;

  MyCustomClipper(this.currentIndex);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    if (currentIndex.value == 0) {
      path.quadraticBezierTo(
        size.width * 0.10,
        size.height * 0.50,
        size.width * 0.20,
        0,
      );
      path.lineTo(size.width * 0.20, 0);
      path.lineTo(size.width, 0);
    } else if (currentIndex.value == 1) {
      path.lineTo(size.width * 0.20, 0);
      path.quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.50,
        size.width * 0.38,
        0,
      );
      path.lineTo(size.width * 0.40, 0);
      path.lineTo(size.width, 0);
    } else if (currentIndex.value == 2) {
      path.lineTo(size.width * 0.40, 0);
      path.quadraticBezierTo(
        size.width * 0.48,
        size.height * 0.50,
        size.width * 0.58,
        0,
      );
      path.lineTo(size.width * 0.60, 0);
      path.lineTo(size.width, 0);
    } else if (currentIndex.value == 3) {
      path.lineTo(size.width * 0.60, 0);
      path.quadraticBezierTo(
        size.width * 0.66,
        size.height * 0.50,
        size.width * 0.76,
        0,
      );
      path.lineTo(size.width * 0.80, 0);
      path.lineTo(size.width, 0);
    } else if (currentIndex.value == 4) {
      path.lineTo(size.width * 0.80, 0);
      path.quadraticBezierTo(
        size.width * 0.86,
        size.height * 0.50,
        size.width * 0.95,
        0,
      );
      path.lineTo(size.width, 0);
      path.lineTo(size.width, 0);
    } else {
      path.quadraticBezierTo(
        size.width * 0.10,
        size.height * 0.50,
        size.width * 0.20,
        0,
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
