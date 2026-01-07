import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/event_controller.dart';

import 'package:house_to_motive/views/screens/followers_screen.dart';

import '../views/screens/chat_screen.dart';

class GetChatSController extends GetxController {
  final RxList<String> userList = <String>[].obs;
  final RxList<String> activeChat = <String>[].obs;
  final RxList<String> nameList = <String>[].obs;
  final RxList<String> picList = <String>[].obs;
  final RxList<String> idsList = <String>[].obs;
  final RxList<String> activeIdsList = <String>[].obs;
  final RxList<String> lastMessageList = <String>[].obs;
  final RxList<String> lastMessageTimeList = <String>[].obs;
  RxString? users;

  RxString name = ''.obs;
  RxString id = ''.obs;
  RxString activeId = ''.obs;
  RxString pic = ''.obs;
  RxString lastMessage = ''.obs;
  RxString lastMessageTime = ''.obs;
  RxString time = ''.obs;
  Future<void> getUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      // Clear existing messages before adding new ones
      userList.clear();
      RxString? currentId =
          FirebaseAuth.instance.currentUser?.uid.toString().obs;

      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          if (doc.id == currentId?.value) {
            List<dynamic>? stringList = doc.data()['activeChatUser'];

            if (stringList != null) {
              //for each active chat user
              stringList.forEach((item) {
                if (item != null) {
                  activeChat.add(item.toString());
                }
              });
            } else {
              log("testing document is null");
            }
          }
        });

        // Print the total length of messages
        log('The Total Length of activeChat are $activeChat');
      }
    } catch (e) {
      Get.snackbar(
        "An Error ",
        e.toString(),
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    }
  }

  Future<void> getActiveChatUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          id.value = doc.data()['userId'];

          if (activeChat.contains(id.value)) {
            name.value = doc.data()['User Name'];
            pic.value = doc.data()['profilePic'];
            lastMessage.value = doc.data()['lastMessage'];
            log('LastMessage ${lastMessage.value}');

            lastMessageTime.value = doc.data()['lastMessageTime'];
            log('LastMessage Time ${lastMessageTime.value}');

            log('active lastMessage ${lastMessageTime.value}');
            activeId.value = doc.data()['userId'];
            lastMessageList.add(lastMessage.value);
            log('LastMessage List print ${lastMessageTimeList}');
            log('This is DateTime.now().day day :${DateTime.now().day}');

            lastMessageTimeList.add(lastMessageTime.value);
            log('LastMessageTime List print ${lastMessageTimeList}');
            nameList.add(name.value);
            picList.add(pic.value);
            activeIdsList.add(activeId.value);
          }
        });
        log('The Total Length of nameList are ${nameList.length}');
        log('The Total Length of picList are ${picList.length}');
        log(
          'The Total Length of lastMessageTime are ${lastMessageTimeList.length}',
        );
        log('The Total Length of lastMessage are ${lastMessageList.length}');
        log('The  lastMessage are $lastMessage');
        log('The lastMessageTime are $lastMessageTime');
      }
    } catch (e) {
      Get.snackbar(
        "An Error ",
        e.toString(),
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  final FirestoreService _firestoreService = FirestoreService();
  TicketController ticketController = Get.put(TicketController());
  List<UserDetail> allUsersDetails = [];

  void fetchUserData() async {
    allUsersDetails = await _firestoreService.fetchAllUserDetails();
  }

  RxBool todayMessage = false.obs;
  RxList todayLastMessageList = [].obs;
  RxList recentLastMessageList = [].obs;
  RxBool recentMessage = false.obs;
  Future<void> checkTodayMessages() async {
    DateTime? dateTime;
    String? formattedDay;
    String pattern = 'dd';

    DateFormat formatter = DateFormat(pattern);
    for (int i = 0; i < lastMessageTimeList.length; i++) {
      dateTime = DateTime.parse(lastMessageTimeList[i]);
      formattedDay = formatter.format(dateTime);
      if (int.parse(formattedDay) == DateTime.now().day) {
        log('today message ');
        todayMessage.value = true;
        todayLastMessageList.add(formattedDay);

        log('todayLastMessageList are $todayLastMessageList');
      } else {
        log('yesterday message ');
      }
    }
  }

  void recentChat() {
    String pattern = 'HH'; // Format pattern for hour (24-hour format)
    DateFormat formatter = DateFormat(pattern);
    for (int i = 0; i < lastMessageTimeList.length; i++) {
      DateTime dateTime = DateTime.parse(lastMessageTimeList[i]);
      String formattedHour = formatter.format(
        dateTime,
      ); // Get the hour from the datetime
      log('This is the hour of the last message: ${int.parse(formattedHour)}');
      log('Current hour: ${DateTime.now().hour}');
      if (int.parse(formattedHour) == DateTime.now().hour) {
        recentMessage.value = true;
        recentLastMessageList.add(formattedHour);
      } else {
        log('Yesterday message');
      }
    }
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserDetail>> fetchAllUserDetails() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserDetail.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user details: $e");
      }
      return [];
    }
  }
}
