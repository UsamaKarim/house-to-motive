import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/controller/get_video_controller.dart';
import 'package:house_to_motive/controller/search_user_controller.dart';
import 'package:house_to_motive/views/screens/navigation_bar/home_page.dart';
import 'package:path/path.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../data/singleton/singleton.dart';
import 'explore_screen.dart';

class UploadYourVideoScreen extends StatefulWidget {
  const UploadYourVideoScreen({super.key});

  @override
  State<UploadYourVideoScreen> createState() => _UploadYourVideoScreenState();
}

class _UploadYourVideoScreenState extends State<UploadYourVideoScreen> {
  final TextEditingController nameController = TextEditingController();
  final SearchUserController searchUserController = SearchUserController();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceRangeController = TextEditingController();

  final VideoControllerUpload videoController =
      Get.put(VideoControllerUpload());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final placeApiController = Get.put(PlacesApi());
    final GetVideoController getVideoController = Get.put(GetVideoController());
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
          'Upload Your Video',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 17.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              controller: descriptionController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText:
                                    'Write description about the video you are going to upload',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 26),
                                hintStyle: TextStyle(
                                  fontFamily: 'ProximaNova',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff424B5A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Obx(() {
                            if (videoController.isUploading.value) {
                              return Container(
                                height: 17.h,
                                width: 32.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.orange,
                                ),
                                child: videoController.isLoading.value == true
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xff025B8F),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Center(
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.network(
                                                videoController
                                                    .thumbnailUrl.value!,
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                              ),
                                              CircularProgressIndicator(
                                                  value: videoController
                                                          .uploadProgress
                                                          .value /
                                                      100),
                                              Text(
                                                  "${videoController.uploadProgress.value.toStringAsFixed(0)}%"),
                                            ],
                                          ),
                                        ),
                                      ),
                              ); // Show loading indicator
                            } else {
                              return Container(
                                height: 17.h,
                                width: 32.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.orange,
                                ),
                                child: videoController.isLoading.value == true
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xff025B8F),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Obx(() {
                                          if (videoController
                                                  .thumbnailUrl.value !=
                                              null) {
                                            return SizedBox(
                                              width:
                                                  128, // Set the width based on your requirements
                                              height:
                                                  128, // Set the height based on your requirements
                                              child: Image.network(
                                                videoController
                                                    .thumbnailUrl.value!,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } else {
                                            return Image.asset(
                                              'assets/pngs/Rectangle 19345.png',
                                              fit: BoxFit.fill,
                                            );
                                          }
                                        }),
                                      ),
                              ); // Show nothing when not uploading
                            }
                          }),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 4.h,
                              width: 32.w,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(12),
                                ),
                                color: const Color(0xff025B8F).withOpacity(0.7),
                              ),
                              child: InkWell(
                                onTap: () {
                                  videoController.pickVideo();
                                  videoController.fieldTextEditingController
                                      .clear();
                                },
                                child: const Center(
                                    child: Text(
                                  'Choose Cover',
                                  style: TextStyle(
                                    fontFamily: 'ProximaNova',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: Color(0xffF6F9FF),
                                  ),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: ListTile(
              //     dense: true,
              //     leading: SvgPicture.asset('assets/svgs/Profile 1.svg'),
              //     title: const Text(
              //       'Tag People',
              //       style: TextStyle(
              //         fontFamily: 'ProximaNova',
              //         fontSize: 12,
              //         fontWeight: FontWeight.w400,
              //         color: Color(0xff424B5A),
              //       ),
              //     ),
              //     trailing: SvgPicture.asset('assets/svgs/Left Arrow Icon.svg'),
              //   ),
              // ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.8.h, vertical: 1.9.h),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Video Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.5.h),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 26),

                    hintStyle: const TextStyle(
                      fontFamily: 'ProximaNova',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff424B5A),
                    ),
                    // prefixIcon: Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 29), // Adjust padding for icon positioning
                    //   child: const Icon(
                    //     Icons.person,
                    //     color: Color(0xff424B5A),
                    //   ),
                    // ),
                    // suffixIcon: Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 37),
                    //   child:const Icon(Icons.description)
                    // ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.8.h,
                ),
                child: TextFormField(
                  controller: priceRangeController,
                  decoration: InputDecoration(
                    hintText: 'Price range',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.5.h),
                        borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 26),

                    hintStyle: const TextStyle(
                      fontFamily: 'ProximaNova',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff424B5A),
                    ),
                    // prefixIcon: Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 29), // Adjust padding for icon positioning
                    //   child: const Icon(
                    //     Icons.person,
                    //     color: Color(0xff424B5A),
                    //   ),
                    // ),
                    // suffixIcon: Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 37),
                    //   child:const Icon(Icons.description)
                    // ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.8.h, vertical: 1.9.h),
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return placeApiController
                        .getSuggestions(textEditingValue.text);
                  },
                  onSelected: (String selection) {
                    placeApiController.searchPlaces(selection);
                    videoController.fieldTextEditingController.text = selection;
                  },
                  fieldViewBuilder: (BuildContext context,
                      fieldTextEditingController,
                      fieldFocusNode,
                      onFieldSubmitted) {
                    return TextFormField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Location',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.5.h),
                            borderSide:
                                const BorderSide(color: Color(0xffD9D9D9))),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        isDense: true,
                        hintStyle: const TextStyle(
                          fontFamily: 'ProximaNova',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff424B5A),
                        ),
                        // prefixIcon: Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal:
                        //           29), // Adjust padding for icon positioning
                        //   child: SvgPicture.asset(
                        //     'assets/svgs/Locationn.svg',
                        //     height: 10, // Adjust the size as needed
                        //     width: 10,
                        //   ),
                        // ),
                        suffixIcon: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  2.h), // Adjust padding for icon positioning
                          child: SvgPicture.asset(
                            'assets/svgs/Locationn.svg',
                            height: 10, // Adjust the size as needed
                            width: 10,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // SizedBox(height: 0.7.h),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: SizedBox(
              //     height: 3.h,
              //     child: ListView.builder(
              //       itemCount: 10,
              //       scrollDirection: Axis.horizontal,
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.only(left: 4, right: 4),
              //           child: Container(
              //             height: 2.5.h,
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(8),
              //                 color: Colors.white,
              //                 border: Border.all(color: Colors.black12)),
              //             child: const Center(
              //               child: Row(
              //                 children: [
              //                   Padding(
              //                     padding: EdgeInsets.symmetric(horizontal: 4.0),
              //                     child: Text(
              //                       '# Hashtags',
              //                       style: TextStyle(
              //                           fontFamily: 'ProximaNova',
              //                           fontSize: 10,
              //                           fontWeight: FontWeight.w400,
              //                           color: Color(0xff7390A1)),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: ListTile(
              //     dense: true,
              //     leading: SvgPicture.asset(
              //       'assets/svgs/Video Slash.svg',
              //     ),
              //     title: const Text(
              //       'Content Disclosure',
              //       style: TextStyle(
              //         fontFamily: 'ProximaNova',
              //         fontSize: 12,
              //         fontWeight: FontWeight.w400,
              //         color: Color(0xff424B5A),
              //       ),
              //     ),
              //     trailing: SvgPicture.asset('assets/svgs/Left Arrow Icon.svg'),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: ListTile(
              //     dense: true,
              //     leading: SvgPicture.asset(
              //       'assets/svgs/Category.svg',
              //     ),
              //     title: const Text(
              //       'Name',
              //       style: TextStyle(
              //         fontFamily: 'ProximaNova',
              //         fontSize: 12,
              //         fontWeight: FontWeight.w400,
              //         color: Color(0xff424B5A),
              //       ),
              //     ),
              //     trailing: SvgPicture.asset('assets/svgs/Left Arrow Icon.svg'),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: ListTile(
              //     dense: true,
              //     leading: SvgPicture.asset(
              //       'assets/svgs/bx_world.svg',
              //     ),
              //     title: const Text(
              //       'Everyone Can View This Post',
              //       style: TextStyle(
              //         fontFamily: 'ProximaNova',
              //         fontSize: 12,
              //         fontWeight: FontWeight.w400,
              //         color: Color(0xff424B5A),
              //       ),
              //     ),
              //     trailing: SvgPicture.asset('assets/svgs/Left Arrow Icon.svg'),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: ListTile(
              //       dense: true,
              //       leading: SvgPicture.asset(
              //         'assets/svgs/Message 18.svg',
              //       ),
              //       title: const Text(
              //         'Allow Comments',
              //         style: TextStyle(
              //           fontFamily: 'ProximaNova',
              //           fontSize: 12,
              //           fontWeight: FontWeight.w400,
              //           color: Color(0xff424B5A),
              //         ),
              //       ),
              //       trailing: Obx(
              //             () => Switch(
              //           activeTrackColor: Colors.green,
              //           value: light0.value,
              //           onChanged: (bool value) {
              //             light0.value = value;
              //           },
              //         ),
              //       )),
              // ),
              // SizedBox(height: 0.8.h),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 30),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Automatically share to:',
              //         style: TextStyle(
              //           fontFamily: 'ProximaNova',
              //           fontSize: 10,
              //           fontWeight: FontWeight.w400,
              //           color: Color(0xff424B5A),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 1.h),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30),
              //   child: Row(
              //     children: [
              //       GestureDetector(
              //         onTap: () {},
              //         child: Container(
              //           height: 5.2.h,
              //           width: 5.2.h,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(50),
              //             border: Border.all(color: Colors.black12),
              //             // color: Colors.black,
              //           ),
              //           child: Center(
              //             child:
              //             SvgPicture.asset('assets/svgs/snapchat-logo.svg'),
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: 1.w),
              //       GestureDetector(
              //         onTap: () {},
              //         child: Container(
              //           height: 5.2.h,
              //           width: 5.2.h,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(50),
              //             border: Border.all(color: Colors.black12),
              //             // color: Colors.black,
              //           ),
              //           child: Center(
              //             child: SvgPicture.asset('assets/svgs/insta-logo.svg'),
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: 1.w),
              //       Container(
              //         height: 5.2.h,
              //         width: 5.2.h,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(50),
              //           border: Border.all(color: Colors.black12),
              //           // color: Colors.black,
              //         ),
              //         child: Center(
              //           child: SvgPicture.asset('assets/svgs/chatbubble.svg'),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 5.5.h,
                        width: screenWidth / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/svgs/carbon_rule-draft.svg'),
                              SizedBox(width: 1.w),
                              Text(
                                'Draft',
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          videoController
                              .getUsername(
                                  FirebaseAuth.instance.currentUser!.uid)
                              .then((value) => videoController
                                      .uploadVideo(
                                    nameController.text.trim(),
                                    descriptionController.text.trim(),
                                    priceRangeController.text,
                                  )
                                      .then((value) {
                                    getVideoController.fetchAndMarkLocations();
                                  }));
                        },
                        child: videoController.isUploading1.value == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff025B8F),
                                ),
                              )
                            : Container(
                                height: 5.5.h,
                                width: screenWidth / 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xff025B8F),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/svgs/eva_upload-outline.svg'),
                                      SizedBox(width: 1.w),
                                      Text(
                                        'Post',
                                        style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoControllerUpload extends GetxController {
  var videoFile = Rxn<File>();
  var isUploading = false.obs;
  var isUploading1 = false.obs;
  var thumbnailUrl = Rxn<String>();
  var uploadProgress = 0.0.obs;
  RxBool isLoading = false.obs;
  String? username;

  final TextEditingController fieldTextEditingController =
      TextEditingController();
  // var thumbnail = Rxn<Image>();

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      videoFile.value = File(result.files.single.path!);
      await generateThumbnail(videoFile.value!);
      isLoading.value = false;
// Generate thumbnail
    } else {
      isLoading.value = false;

      // User canceled the picker
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUsername(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        username = userDoc['User Name'];
        print("userName: $username");
        return username;
      } else {
        return null; // User document not found
      }
    } catch (e) {
      print('Error fetching username: $e');
      return null; // Error occurred
    }
  }

  // Function to generate a thumbnail from a video file
  Future<void> generateThumbnail(File video) async {
    isLoading.value = true;
    final uint8list = await VideoThumbnail.thumbnailData(
      video: video.path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 300, // Specify the width of the thumbnail
      quality: 35,
    );
    isLoading.value = true;

    if (uint8list != null) {
      isLoading.value = true;

      // Upload thumbnail to Firebase Storage
      String thumbnailFileName =
          'thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference thumbnailStorageRef =
          FirebaseStorage.instance.ref().child('thumbnails/$thumbnailFileName');
      UploadTask thumbnailUploadTask = thumbnailStorageRef.putData(uint8list);
      isLoading.value = true;

      // Wait for the thumbnail upload to complete
      await thumbnailUploadTask;

      // Get the download URL of the uploaded thumbnail
      thumbnailUrl.value = await thumbnailStorageRef.getDownloadURL();
      isLoading.value = false;
    }
  }

  Future<void> uploadVideo(
    String name,
    description,
    priceRange,
  ) async {
    if (fieldTextEditingController.text.isEmpty) {
      if (name.isEmpty) {
        Get.snackbar('Error', 'Name field is empty. Please select a Name.',
            colorText: Colors.white, backgroundColor: const Color(0xff025B8F));
      } else if (description.isEmpty) {
        Get.snackbar(
            'Error', 'Description field is empty. Please select a description.',
            colorText: Colors.white, backgroundColor: const Color(0xff025B8F));
      } else if (priceRange.isEmpty) {
        Get.snackbar('Error', 'Please enter Price Range',
            colorText: Colors.white, backgroundColor: const Color(0xff025B8F));
      } else {
        Get.snackbar(
            'Error', 'Location field is empty. Please select a location.',
            colorText: Colors.white, backgroundColor: const Color(0xff025B8F));
        log('Location field is empty. Please select a location.');
        return;
      }
    }
    if (videoFile.value == null || thumbnailUrl.value == null) {
      // Handle the case where no file or thumbnail is selected
      log('Video file or thumbnail is missing. Please select both.');
      return;
    }
    try {
      isUploading1.value = true;
      // Get the current user's unique ID
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      String fileName = basename(videoFile.value!.path);
      // Upload the video to Firebase Storage
      Reference videoStorageRef =
          FirebaseStorage.instance.ref().child('user_videos/$userId/$fileName');
      UploadTask videoUploadTask = videoStorageRef.putFile(videoFile.value!);
      // Listen for changes in upload progress
      videoUploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      });
      // Wait for the video upload to complete
      await videoUploadTask;
      // Get the download URL of the uploaded video
      String videoDownloadUrl = await videoStorageRef.getDownloadURL();
      isUploading1.value = true;

      double lat = Singleton().selectedLatitude;
      double lng = Singleton().selectedLongitude;
      // Add the video metadata to Firestore
      await FirebaseFirestore.instance.collection('videos').add({
        'userId': userId,
        'videoUrl': videoDownloadUrl,
        'thumbnailUrl': thumbnailUrl.value,
        'timestamp': FieldValue.serverTimestamp(), // Optional: Add timestamp
        'location': fieldTextEditingController.text,
        'latitude': lat, // Storing Latitude
        'longitude': lng, // Storing Longitude
        'userName': username,
        'videoName': name,
        'description': description,
        'priceRange': priceRange,
        // 'username' : data!['User Name'],
      }).then((value) {
        isUploading1.value = false;

        Get.snackbar('Status', 'video uploaded',
            colorText: Colors.white, backgroundColor: const Color(0xff025B8F));
        Get.off(() => HomePage());
        isLoading.value = false;
      });
    } on FirebaseException catch (e) {
      log("Unexpected error occurred :${e.toString()}");
      isUploading1.value = false;
    } finally {
      isUploading1.value = false;
    }
  }
}
