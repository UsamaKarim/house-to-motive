import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentUserController extends GetxController {
  final BuildContext context;
  CurrentUserController({required this.context});
  //get Current user data from firebase user collection
  RxString currentUserName="".obs;
  RxString currentUserProfile="".obs;
  RxString currentUserId="".obs;
  Future<DocumentSnapshot?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    log("user id :${user?.uid}");
    log("user name :${user?.displayName}");
    log("user email :${user?.email}");
    try {
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        currentUserName.value=userDoc["User Name"];
        currentUserProfile.value=userDoc["profilePic"];
        currentUserId.value=userDoc["userId"];
        return userDoc.exists ? userDoc : null;
      } else {
        return null; // User not logged in
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return null;
  }


}
