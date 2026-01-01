import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userName;
  final String userId;
  final String profilePic;

  User({
    required this.userName,
    required this.userId,
    required this.profilePic,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      userName: data['User Name'],
      userId: data['userId'],
      profilePic: data['profilePic'],
    );
  }
}

class Event {
  final String description;
  final DateTime endTime;
  final String eventName;
  final double familyPrice;
  final String id;
  final bool isEventFavourite;
  final bool isPaid;
  final String location;
  final String photoURL;
  final bool private;
  final DateTime startTime;
  final String uid;
  final String userName;
  final String userProfilePic;

  Event({
    required this.description,
    required this.endTime,
    required this.eventName,
    required this.familyPrice,
    required this.id,
    required this.isEventFavourite,
    required this.isPaid,
    required this.location,
    required this.photoURL,
    required this.private,
    required this.startTime,
    required this.uid,
    required this.userName,
    required this.userProfilePic,
  });

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      description: data['description'],
      endTime:  _parseTimestamp(data['endTime']),
      eventName: data['eventName'],
      familyPrice: data['familyPrice'],
      id: data['id'],
      isEventFavourite: data['isEventFavourite'],
      isPaid: data['isPaid'],
      location: data['location'],
      photoURL: data['photoURL'],
      private: data['private'],
      startTime:  _parseTimestamp(data['startTime']),
      uid: data['uid'],
      userName: data['userName'],
      userProfilePic: data['userProfilePic'],
    );
  }

  // Modify this method to handle your date format
  static DateTime _parseTimestamp(String timestamp) {
    try {
      // Example for custom parsing
      // Assuming timestamp is in format "HH:mm"
      final parts = timestamp.split(':');
      if (parts.length == 2) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      } else {
        return DateTime.parse(timestamp); // Fallback to default parsing
      }
    } catch (e) {
      throw FormatException('Invalid date format: $timestamp');
    }
  }



}
