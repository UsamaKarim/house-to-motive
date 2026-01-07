import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../data/models/user_model.dart';

class SearchUserController extends GetxController {
  RxList<String> userNameList = <String>[].obs;
  RxList<String> userPicsList = <String>[].obs;
  RxList<String> userIdList = <String>[].obs;
  RxList<Map<String, String>> userList = <Map<String, String>>[].obs;
  RxList<Map<String, String>> eventsList = <Map<String, String>>[].obs;

  RxString profileImage = ''.obs;
  RxString userName = ''.obs;
  RxString userIds = ''.obs;
  var users = <User>[].obs;
  var events = <Event>[].obs;
  var searchText = ''.obs;
  // getAllUsers
  Future<void> getApplicationUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        String userName = userData['User Name'] ?? 'Unknown';
        String userId = userData['userId'] ?? 'Unknown';
        String profilePic = userData['profilePic'] ?? '';
        log('userName is printed $userName}');
        if (!userIdList.contains(userId)) {
          userList.add({
            'userName': userName,
            'userId': userId,
            'profilePic': profilePic,
          });
        }
      }
    } catch (e) {
      log('Error Something went wrong: ${e.toString()}');
    }
  }

  //current user
  void getCurrentUserData(String videoId) {
    for (int i = 0; i < userNameList.length; i++) {
      String? userId = userIdList[i];
      log('userId is are $userId');

      // Check if userId is null and handle it
      if (userId == videoId) {
        profileImage.value = userPicsList[i];
        userName.value = userNameList[i];
        userIds.value = userIdList[i];
        log('Current profileImage is $profileImage');
        log('Current userName is $userName');
        log('Current userIds is $userIds');
      }

      // Check if userName is null and handle it
    }
  }

  //search users method
  RxList<Map<String, String>> searchResults = <Map<String, String>>[].obs;
  void queryChange(String query) {
    searchResults =
        userList
            .where(
              (user) =>
                  user['userName']?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false,
            )
            .toList()
            .obs;
  }
  //all events

  Future<void> getApplicationEvents() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('tickets').get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        String adultPrice = userData['adultPrice']?.toString() ?? 'Unknown';
        String childPrice = userData['childPrice']?.toString() ?? 'Unknown';
        String date =
            userData['date'] is Timestamp
                ? DateFormat(
                  'yyyy-MM-dd',
                ).format((userData['date'] as Timestamp).toDate())
                : userData['date']?.toString() ?? '';
        String description = userData['description']?.toString() ?? '';
        String endTime = userData['endTime']?.toString() ?? '';
        String eventName = userData['eventName']?.toString() ?? '';
        String familyPrice = userData['familyPrice']?.toString() ?? '';
        String id = userData['id']?.toString() ?? '';
        String isEventFavourite =
            userData['isEventFavourite']?.toString() ?? '';
        String isPaid = userData['isPaid']?.toString() ?? '';
        String location = userData['location']?.toString() ?? '';
        String photoURL = userData['photoURL']?.toString() ?? '';
        String private = userData['private']?.toString() ?? '';
        String startTime = userData['startTime']?.toString() ?? '';
        String uid = userData['uid']?.toString() ?? '';
        String userName = userData['userName']?.toString() ?? '';
        String userProfilePic = userData['userProfilePic']?.toString() ?? '';
        eventsList.add({
          'adultPrice': adultPrice,
          'childPrice': childPrice,
          'date': date,
          'description': description,
          'endTime': endTime,
          'eventName': eventName,
          'familyPrice': familyPrice,
          'id': id,
          'isEventFavourite': isEventFavourite,
          'isPaid': isPaid,
          'location': location,
          'photoURL': photoURL,
          'private': private,
          'startTime': startTime,
          'uid': uid,
          'userName': userName,
          'userProfilePic': userProfilePic,
        });
      }
    } catch (e) {
      log('Error Something went wrong: ${e.toString()}');
    }
  }

  RxList<Map<String, String>> searchEventsResults = <Map<String, String>>[].obs;
  void queryEventsChange(String query) {
    searchEventsResults =
        eventsList
            .where(
              (user) =>
                  user['eventName']?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false,
            )
            .toList()
            .obs;
  }

  void combinedQueryChange(String query) {
    queryChange(query); // Call the user search method
    queryEventsChange(query); // Call the event search method

    // You can add additional logic here if needed
    log('Combined search performed for query: $query');
  }
}
