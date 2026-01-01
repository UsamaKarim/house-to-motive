// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ChatModel{
//    String? id;
//    String? text;
//    String? senderEmail;
//    String? receiverEmail;
//    String? timeStamp;
//    ChatModel({this.id,this.text,this.senderEmail,this.receiverEmail,
//    this.timeStamp});
//
//    Map<String, dynamic> toMap() {
//      return {
//        'id': '',
//        'text': text,
//        'senderId': senderEmail,
//        'receiverId': receiverEmail,
//        'timestamp': timeStamp,
//      };
//    }
//
//    factory ChatModel.fromMap(Map<String, dynamic> map) {
//      return ChatModel(
//        id: map['id'],
//        text: map['text'],
//        senderEmail: map['senderId'],
//        receiverEmail: map['receiverId'],
//        timeStamp: (map['timestamp'] is Timestamp) ? map['timestamp'].toDate() : DateTime.parse(map['timestamp']),
//      );
//    }
//
// }