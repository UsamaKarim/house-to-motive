// import 'package:firebase_messaging/firebase_messaging.dart';
//
// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   if (message.notification != null) {
//   }
//
// }
//
// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//
//   Future<void> initNotification() async {
//     await _firebaseMessaging.requestPermission(
//       sound: true,
//       alert: true,
//       announcement: true,
//       badge: true,
//     );
//     final fCMToken = await _firebaseMessaging.getToken();
//     print('Token: $fCMToken');
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//   }
// }
