import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/controller/search_user_controller.dart';
import 'package:house_to_motive/views/screens/user_profile_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'ArcadeScreen.dart';
import '../../widgets/appbar_location.dart';
import 'explore_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // final NotificationServices notificationServices = NotificationServices();
  final placeApiController = Get.put(PlacesApi());
  TextEditingController searchController = TextEditingController();

  // This will hold the filtered list of searches
  List<String> filteredSearches = [];
  final SearchUserController searchUserController =
      Get.put(SearchUserController());

  @override
  void initState() {
    super.initState();
    placeApiController.getRecentSearchesFromSharedPreferences();
    // Listen to changes in the search field and filter the recent searches accordingly
    searchController.addListener(_filterSearches);
    searchUserController.getApplicationUsers();
    searchUserController.getApplicationEvents();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    searchController.dispose();
    super.dispose();
  }

  void _filterSearches() {
    // Use the text from the searchController to filter the recent searches
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSearches = placeApiController.recentSearches.where((search) {
        return search.toLowerCase().contains(query);
      }).toList();
    });
  }

  // void _navigateToExploreScreen(String location) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => HomePage(
  //         selectedIndex: 1,
  //         searchQuery: location,
  //         status: true,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: 1.6.w),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      searchUserController.combinedQueryChange(value);
                      if(value.isEmpty){
                        searchUserController.searchEventsResults.clear();
                        searchUserController.searchResults.clear();
                      }

                    },
                    decoration: InputDecoration(
                      hintText: "Search what’s near me",
                      hintStyle: const TextStyle(
                        fontFamily: 'ProximaNova',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff424B5A),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/svgs/search-normal.svg',
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 18),
                //       child: Text(
                //         'Recent Searches',
                //         style: GoogleFonts.inter(
                //           fontWeight: FontWeight.w400,
                //           fontSize: 18,
                //           color: const Color(0xff025B8F),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                searchUserController.searchResults.isNotEmpty
                    ? Obx(
                        () => ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: searchUserController.searchResults.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => UserProfileScreen(
                                    userId: searchUserController
                                        .searchResults[index]['userId']!,
                                    userName: searchUserController
                                        .searchResults[index]['userName']!,
                                    profilePic: searchUserController
                                        .searchResults[index]['profilePic']!));
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: searchUserController
                                                      .searchResults[index]
                                                  ['profilePic'] !=
                                              null &&
                                          searchUserController
                                              .searchResults[index]
                                                  ['profilePic']!
                                              .isNotEmpty
                                      ? NetworkImage(searchUserController
                                          .searchResults[index]['profilePic']!)
                                      : const AssetImage('assets/pngs/user.png')
                                          as ImageProvider,
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                    // Handle errors here if necessary
                                  },
                                ),
                                title: Text(searchUserController
                                        .searchResults[index]['userName'] ??
                                    ""),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                Obx(()=>
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchUserController.searchEventsResults.length,
                        itemBuilder: (context, index) {
                          Rx<String?> isFavorite = searchUserController.searchEventsResults[index]['isEventFavourite'].obs;

                          return GestureDetector(
                            onTap: () {
                              DateTime parseTime(String timeString) {
                                final timeParts = timeString.split(':');
                                final now = DateTime.now();
                                return DateTime(now.year, now.month, now.day, int.parse(timeParts[0]), int.parse(timeParts[1]));
                              }


                              // Function to convert String date to Timestamp
                              Timestamp parseDateToTimestamp(String dateString) {
                                // Parse the string into a DateTime object
                                DateTime dateTime = DateTime.parse(dateString);
                                // Convert DateTime to Timestamp
                                return Timestamp.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
                              }

                              Get.to(
                                    () => ArcadeScreen(
                                  description: searchUserController.searchEventsResults[index]['description'],
                                  photoURL: searchUserController.searchEventsResults[index]['photoURL'],
                                  startTime: parseTime(searchUserController.searchEventsResults[index]['startTime']!).toIso8601String(),
                                  endTime: parseTime(searchUserController.searchEventsResults[index]['endTime']!).toIso8601String(),
                                  eventName: searchUserController.searchEventsResults[index]['eventName'],
                                  location: searchUserController.searchEventsResults[index]['location'],
                                  date: parseDateToTimestamp(searchUserController.searchEventsResults[index]['date'] ?? ""), // Convert to Timestamp
                                  familyPrice: searchUserController.searchEventsResults[index]['familyPrice'],
                                  adultPrice: searchUserController.searchEventsResults[index]['adultPrice'],
                                  childPrice: searchUserController.searchEventsResults[index]['childPrice'],
                                  oragnizerName: searchUserController.searchEventsResults[index]['userName'],
                                  OrganizerProfilePic: searchUserController.searchEventsResults[index]['userProfilePic'],
                                  ticketUid: searchUserController.searchEventsResults[index]['uid'],
                                  isPaid: searchUserController.searchEventsResults[index]['isPaid'],
                                  isEventFavourite: searchUserController.searchEventsResults[index]['isEventFavourite'],
                                ),
                              );


                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Container(
                                    height: screenHeight * 0.32,
                                    width: screenWidth / 1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                searchUserController.searchEventsResults[index]['eventName'].toString().length > 35
                                                    ? '${searchUserController.searchEventsResults[index]['eventName'].toString().substring(0, 35)}..'
                                                    : searchUserController.searchEventsResults[index]['eventName'].toString(),
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 0.3.h),
                                              Row(
                                                children: [
                                                  SvgPicture.asset('assets/svgs/home/map-pin.svg'),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    searchUserController.searchEventsResults[index]['location'].toString().length > 30
                                                        ? '${searchUserController.searchEventsResults[index]['location'].toString().substring(0, 30)}..'
                                                        : searchUserController.searchEventsResults[index]['location'].toString(),
                                                    style: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w400,
                                                      color: const Color(0xff7390A1),
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.27,
                                  width: Get.width / 1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(searchUserController.searchEventsResults[index]['photoURL'].toString()),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Optionally add favorite functionality here
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                ),

                SizedBox(height: 8.h),

              ],
            ),
          ),
        ),
      ),

    );
  }
}

// AppBar(
// centerTitle: true,
// backgroundColor: const Color(0xff025B8F),
// leading: Padding(
// padding: const EdgeInsets.only(left: 4),
// child: Image.asset('assets/pngs/htmlogo.png'),
// ),
// title: Column(
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Image.asset(
// 'assets/appbar/Vector@2x.png',
// height: 9,
// width: 9,
// ),
// SizedBox(width: 1.h),
// const Text(
// 'My Location',
// style: TextStyle(
// fontSize: 12,
// fontWeight: FontWeight.w600,
// color: Colors.white),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(left: 8.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// SizedBox(width: 1.h),
// const Text(
// '73 Newport Road, Carnbo',
// style: TextStyle(
// fontSize: 10,
// fontWeight: FontWeight.w400,
// color: Colors.white),
// ),
// SizedBox(width: 1.h),
// Image.asset(
// 'assets/appbar/Vector1.png',
// height: 9,
// width: 9,
// ),
// ],
// ),
// ),
// ],
// ),
// actions: [
// GestureDetector(
// onTap: (){
// Get.to(() => FavList());
// },
// child: SvgPicture.asset('assets/appbar/heart.svg')),
// const SizedBox(width: 10),
// GestureDetector(
// onTap: (){
// Get.to(() => NotificationScreen());
// },
// child: SvgPicture.asset('assets/appbar/Notification.svg')),
// const SizedBox(width: 10),
// ],
// ),
