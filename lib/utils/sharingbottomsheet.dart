import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_to_motive/controller/event_controller.dart';
import 'package:house_to_motive/views/screens/chatRoom.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

void openBottomSheetSharing(String url, BuildContext context) {
  final TextEditingController searchController = TextEditingController();

  final FirestoreService firestoreService = Get.put(FirestoreService());
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Get.bottomSheet(
    SizedBox(
      height: 70.h,
      child: Padding(
        padding: EdgeInsets.all(20.px),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 2.h,
                  vertical: 1.3.h,
                ),
                isCollapsed: true,
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.h),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                suffixIcon: Icon(Icons.person_add_alt_outlined, size: 20.px),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: firestoreService.userList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ChatPage(
                              name: firestoreService.userList[index]['Name']!,
                              receiverId:
                                  firestoreService.userList[index]['userId']!,
                              chatRoomId: chatRoomId(
                                firestoreService.userList[index]['userId']!,
                                FirebaseAuth.instance.currentUser?.uid ?? '',
                              ),
                              receiverEmail:
                                  firestoreService.userList[index]['userId']!,
                              urls: url,
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            firestoreService
                                    .userList[index]['profileImage']!
                                    .isNotEmpty
                                ? firestoreService
                                    .userList[index]['profileImage']!
                                : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                            scale: 1.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        firestoreService.userList[index]['Name']!,
                        style: TextStyle(
                          fontSize: 14.px,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'bold',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Share',
                  style: TextStyle(
                    fontFamily: 'bold',
                    fontSize: 18.px,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 1.h),
                GestureDetector(
                  onTap: () {
                    Share.share(url); // Share the URL with external apps
                  },
                  child: Icon(Icons.share, size: 40.px, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
  );
}
