import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String? id;
  final bool? isPaid;
  final bool? private;
  final bool? commentDisable;
  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? location;
  final String? eventName;
  final String? description;
  final String? photoURL;
  final bool? isEventFavourite;
  final String? childPrice;
  final String? adultPrice;
  final String? familyPrice;
  final String? userProfilePic;
  final String? userName;
  final String? uid;

  Ticket({
    this.id,
    this.isPaid,
    this.date,
    this.startTime,
    this.endTime,
    this.location,
    this.eventName,
    this.description,
    this.photoURL,
    this.private,
    this.commentDisable,
    this.isEventFavourite,
    this.adultPrice,
    this.childPrice,
    this.familyPrice,
    this.userProfilePic,
    this.userName,
    this.uid,
  });

  // Convert Ticket to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isPaid': isPaid,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'startTime': startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'location': location,
      'eventName': eventName,
      'description': description,
      'photoURL': photoURL,
      'private': private,
      'commentDisable': commentDisable,
      'isEventFavourite': isEventFavourite,
      'childPrice': childPrice,
      'adultPrice': adultPrice,
      'familyPrice': familyPrice,
      'userName': userName,
      'userProfilePic': userProfilePic,
      'uid': uid,
    };
  }

  // Convert Map to Ticket
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      isPaid: map['isPaid'],
      date: (map['date'] as Timestamp?)?.toDate(),
      startTime: map['startTime'] != null ? _parseTimeOfDay(map['startTime']) : null,
      endTime: map['endTime'] != null ? _parseTimeOfDay(map['endTime']) : null,
      location: map['location'],
      eventName: map['eventName'],
      description: map['description'],
      photoURL: map['photoURL'],
      private: map['private'],
      commentDisable: map['commentDisable'],
      isEventFavourite: map['isEventFavourite'],
      childPrice: map['childPrice'],
      adultPrice: map['adultPrice'],
      familyPrice: map['familyPrice'],
      userProfilePic: map['userProfilePic'],
      userName: map['userName'],
      uid: map['uid'],
    );
  }

  // Helper method to parse TimeOfDay
  static TimeOfDay? _parseTimeOfDay(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
