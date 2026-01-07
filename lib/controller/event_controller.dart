import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/event_model.dart';

RxBool isSelected = false.obs;
RxBool isCommentDisable = false.obs;
RxBool isPrivate = false.obs;

class TicketController extends GetxController {
  final CollectionReference ticketsCollection = FirebaseFirestore.instance
      .collection('tickets');
  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController childPriceController = TextEditingController();
  final TextEditingController adultPriceController = TextEditingController();
  final TextEditingController familyPriceController = TextEditingController();

  Future<String?> uploadImage(File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('ticket_images')
          .child(DateTime.now().toString());
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  Rx<TimeOfDay> selectedTimeEnd = TimeOfDay.now().obs;

  RxBool isPrivate = false.obs;
  RxBool isCommentDisable = false.obs;
  RxBool isEventFavourite = false.obs;

  Rx<DateTime> selectedDay = DateTime.now().obs;

  void onDaySelected(DateTime day, DateTime focusedDay) {
    selectedDay(day);
  }

  Rx<DateTime> getSelectedDay() => selectedDay;

  void togglePrivate(bool value) {
    isPrivate.value = value;
  }

  void toggleCommentDisable(bool value) {
    isCommentDisable.value = value;
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay initialTime = selectedTime.value;
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null && picked != initialTime) {
      selectedTime.value = picked;
    }
  }

  Future<void> selectTimeEnd(BuildContext context) async {
    TimeOfDay initialTime = selectedTimeEnd.value;
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null && picked != initialTime) {
      selectedTimeEnd.value = picked;
    }
  }

  var selectedImage = Rx<File?>(null);

  // picking profile image
  pickedImage() async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        log(selectedImage.value.toString());
      } else {
        Get.snackbar("No Image", "Please Select Image");
      }
    } catch (e) {
      Get.snackbar("An Error", " ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    // Assuming you have a way to get the current user's ID
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future uploadImageToFirebase({
    isPaid,
    date,
    startTime,
    endTime,
    location,
    eventName,
    description,
    private,
    commentDisable,
    isEventFavourite,
    childPriceController,
    adultPriceController,
    familyPriceController,
    uid,
  }) async {
    if (selectedImage.value == null) return;

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child(
      'images/${DateTime.now().millisecondsSinceEpoch}.png',
    );

    UploadTask uploadTask = storageReference.putFile(selectedImage.value!);
    await uploadTask.whenComplete(() => log('Image uploaded to Firebase'));

    String? imageUrl = await storageReference.getDownloadURL();
    if (kDebugMode) {
      print('Download URL: $imageUrl');
    }

    if (imageUrl.isNotEmpty) {
      Map<String, dynamic>? userDetails = await getCurrentUserDetails();
      addTicket(
        isPaid: isPaid,
        date: date,
        startTime: startTime,
        endTime: endTime,
        locationController: locationController.text,
        childPriceController: childPriceController.text,
        eventName: eventName,
        description: description,
        photoURL: imageUrl,
        private: private,
        commentDisable: commentDisable,
        isEventFavourite: isEventFavourite,
        familyPriceController: familyPriceController.text,
        adultPriceController: adultPriceController.text,
        userName: userDetails?['User Name'],
        userProfilePic: userDetails?['profilePic'] ?? "",
        uid: FirebaseAuth.instance.currentUser!.uid,
      );
    }
  }

  Future<void> updateTicketCollection(
    RxString ticketId,
    RxBool isEventFavourite,
  ) async {
    FirebaseFirestore.instance.collection('tickets').doc(ticketId.value).update(
      {'isEventFavourite': isEventFavourite.value},
    );
  }

  void addTicket({
    required bool isPaid,
    required Rx<DateTime> date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String locationController,
    required String eventName,
    required String description,
    required String photoURL,
    required bool private,
    required bool commentDisable,
    required isEventFavourite,
    required String childPriceController,
    required String adultPriceController,
    required String familyPriceController,
    required String userName,
    required String userProfilePic,
    required String uid,
  }) {
    String id = ticketsCollection.doc().id;
    bool isPaid = isSelected.value;

    Ticket newTicket = Ticket(
      id: id,
      isPaid: isPaid,
      date: date.value,
      startTime: startTime,
      endTime: endTime,
      location: locationController,
      eventName: eventName,
      description: description,
      photoURL: photoURL,
      private: private,
      commentDisable: commentDisable,
      isEventFavourite: isEventFavourite == false.obs,
      adultPrice: adultPriceController,
      childPrice: childPriceController,
      familyPrice: familyPriceController,
      userName: userName,
      userProfilePic: userProfilePic,
      uid: FirebaseAuth.instance.currentUser?.uid,
    );

    ticketsCollection
        .doc(id)
        .set(newTicket.toMap())
        .then((value) => log('Ticket added to Firestore'))
        .catchError((error) => log('Failed to add ticket: $error'));
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> toggleFollowUser(
    String currentUserUid,
    String userToToggleUid,
  ) async {
    try {
      // Check if currentUserUid is the same as userToToggleUid
      if (currentUserUid == userToToggleUid) {
        if (kDebugMode) {
          print("A user cannot follow themselves.");
        }
        Get.snackbar('message', 'A user cannot follow themselves.');
        return false; // Early exit
      }

      final DocumentSnapshot currentUserDoc =
          await _firestore.collection('users').doc(currentUserUid).get();
      final Map<String, dynamic> currentUserData =
          currentUserDoc.data() as Map<String, dynamic>;

      // Assuming the field exists as an empty array if not found
      final List<dynamic> followingList = currentUserData['following'] ?? [];
      final bool isFollowing = followingList.contains(userToToggleUid);

      if (isFollowing) {
        // Remove userToToggleUid from the following list of currentUserUid
        await _firestore.collection('users').doc(currentUserUid).update({
          'following': FieldValue.arrayRemove([userToToggleUid]),
        });
        // Remove currentUserUid from the followers list of userToToggleUid
        await _firestore.collection('users').doc(userToToggleUid).update({
          'followers': FieldValue.arrayRemove([currentUserUid]),
        });
      } else {
        // Add userToToggleUid to the following list of currentUserUid
        await _firestore.collection('users').doc(currentUserUid).update({
          'following': FieldValue.arrayUnion([userToToggleUid]),
        });
        // Add currentUserUid to the followers list of userToToggleUid
        await _firestore.collection('users').doc(userToToggleUid).update({
          'followers': FieldValue.arrayUnion([currentUserUid]),
        });
      }

      // Return the updated follow status
      return !isFollowing;
    } catch (e) {
      if (kDebugMode) {
        print("Error toggling follow status: $e");
      }
      return false; // Return false if an error occurs
    }
  }

  final FirestoreService _firestoreService = Get.put(FirestoreService());
  final RxList<String> followingList = <String>[].obs;
  final RxList<String> followersList = <String>[].obs;

  void fetchFollowingList(String currentUserUid) async {
    followingList.value = await _firestoreService.getFollowingList(
      currentUserUid,
    );
  }

  void fetchFollowersList(String currentUserUid) async {
    followersList.value = await _firestoreService.getFollowersList(
      currentUserUid,
    );
  }

  Future<void> unfollowUser(
    String currentUserId,
    String userToUnfollowId,
  ) async {
    // Remove from the local following list
    followingList.remove(userToUnfollowId);

    // Update Firestore to remove the user from the current user's following list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({
          'following': FieldValue.arrayRemove([userToUnfollowId]),
        });

    // Optionally, remove the current user from the unfollowed user's followers list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userToUnfollowId)
        .update({
          'followers': FieldValue.arrayRemove([currentUserId]),
        });
  }

  Future<void> removeFollower(
    String currentUserId,
    String followerUserId,
  ) async {
    followersList.remove(followerUserId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({
          'followers': FieldValue.arrayRemove([followerUserId]),
        });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followerUserId)
        .update({
          'following': FieldValue.arrayRemove([currentUserId]),
        });
  }

  Future<void> fetchFavouriteTickets() async {
    // Initialize Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Query to get documents where isEventFavourite is true
      QuerySnapshot querySnapshot =
          await firestore
              .collection('tickets')
              .where('isEventFavourite', isEqualTo: true)
              .get();

      // Check if documents are retrieved
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          // Extract data from each document
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          log('Document ID: ${doc.id}');
          log('Data: $data');
        }
      } else {
        log('No favourite tickets found.');
      }
    } catch (e) {
      log('Error fetching tickets: $e');
    }
  }
}

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getFollowingList(String currentUserUid) async {
    try {
      final DocumentSnapshot currentUserDoc =
          await _firestore.collection('users').doc(currentUserUid).get();
      final List<dynamic>? followingList = currentUserDoc['following'];

      if (followingList != null) {
        return followingList.cast<String>();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting following list: $e");
      }
      return [];
    }
  }

  Future<List<String>> getFollowersList(String currentUserUid) async {
    try {
      final DocumentSnapshot currentUserDoc =
          await _firestore.collection('users').doc(currentUserUid).get();
      final List<dynamic>? followersList = currentUserDoc['followers'];

      if (followersList != null) {
        return followersList.cast<String>();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting followers list: $e");
      }
      return [];
    }
  }

  RxList<Map<String, String>> userList = <Map<String, String>>[].obs;
  RxList<String> indexList = <String>[].obs;
  List<dynamic> followers = <dynamic>[].obs;
  Future<void> getCurrentUser() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (currentUserId.isEmpty) {
        log('No current user logged in.');
        return;
      }
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        followers = userData['followers'] ?? [];
      } else {
        log('User document does not exist.');
      }
    } catch (e) {
      log('Error retrieving current user: ${e.toString()}');
    }
  }

  Future<void> fetchFollowersData(List<dynamic> followers) async {
    // Fetch all user documents once
    QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    if (userSnapshot.docs.isNotEmpty) {
      for (int i = 0; i < followers.length; i++) {
        QueryDocumentSnapshot? userDoc = userSnapshot.docs.firstWhere(
          (doc) => doc.id == followers[i],
        );

        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String userName = userData['User Name'] ?? 'Unknown';
        String userId = userData['userId'] ?? 'Unknown';
        String profilePic = userData['profilePic'] ?? '';
        bool userExists = userList.any((user) => user['userId'] == userId);
        if (!userExists) {
          userList.add({
            'Name': userName,
            'userId': userId,
            'profileImage': profilePic,
          });
        }
        log('userName $userName');
        log('userId $userId');
        log('profilePic $profilePic');
        indexList.add(userName);
        log('indexList ${indexList.length}');

        log('userList length ${userList.length}');
      }
    }
  }
}
