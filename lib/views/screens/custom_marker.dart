import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TicketInfo {
  String id;
  String eventName;
  String photoURL;
  String location;
  Timestamp date; // Explicitly using Timestamp
  String adultPrice;
  String childPrice;
  String familyPrice;
  String startTime;
  String endTime;
  String description;
  bool   isPaid;
  String organizarName;
  String organizarImage;
  String ticketUid;
  bool   isFollow;

  TicketInfo({
    required this.id,
    required this.eventName,
    required this.photoURL,
    required this.location,
    required this.date, // Making it required and explicitly of type Timestamp
    required this.adultPrice,
    required this.familyPrice,
    required this.childPrice,
    required this.endTime,
    required this.startTime,
    required this.description,
    required this.isPaid,
    required this.organizarName,
    required this.organizarImage,
    required this.isFollow,
    required this.ticketUid

  });
}


class videoInfo {
  // Define your variables with Rx types
  var userId = ''.obs;
  var location = ''.obs;
  var videoUrl = ''.obs;
  var thumbnailUrl = ''.obs;
  var userName = ''.obs;

  // Constructor to initialize values
  videoInfo({
    required String userId,
    required String location,
    required String videoUrl,
    required String thumbnailUrl,
    required String userName,
  }) {
    this.userId.value = userId;
    this.location.value = location;
    this.videoUrl.value = videoUrl;
    this.thumbnailUrl.value = thumbnailUrl;
    this.userName.value = userName;
  }
}




