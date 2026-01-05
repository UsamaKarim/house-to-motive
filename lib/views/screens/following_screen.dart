// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import '../../controller/event_controller.dart';
// import 'followers_screen.dart';
// import 'home_screens/home_model.dart';
//
// class FollowingScreen extends StatefulWidget {
//   const FollowingScreen({super.key});
//
//   @override
//   State<FollowingScreen> createState() => _FollowingScreenState();
// }
//
// class _FollowingScreenState extends State<FollowingScreen> {
//   // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   TicketController ticketController = Get.put(TicketController());
//   final FirestoreService _firestoreService = FirestoreService();
//   List<UserDetail> allUsersDetails = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//     print("Following List: ${ticketController.followingList.length}");
//   }
//
//   void fetchUserData() async {
//     allUsersDetails = await _firestoreService.fetchAllUserDetails();
//     setState(() {
//       // print('This is users List : ${}')
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _firestoreService.fetchAllUserDetails();
//     ticketController.fetchFollowingList(FirebaseAuth.instance.currentUser!.uid);
//     print("Following List in Build : ${ticketController.followingList.length}");
//
//     _firestoreService.fetchAllUserDetails();
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//             size: 19,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xff025B8F),
//         title: Text(
//           'Following',
//           style: GoogleFonts.inter(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: FutureBuilder(
//         future: _firestoreService.fetchAllUserDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child:
//                   CircularProgressIndicator(), // Show circular progress indicator
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'), // Show error message
//             );
//           } else {
//             // Data has been loaded successfully, build the ListView
//             return ListView.builder(
//               shrinkWrap: true,
//               itemCount: ticketController.followingList.length,
//               itemBuilder: (context, index) {
//                 final String userId = ticketController.followingList[index];
//                 UserDetail? userDetails;
//
//                 // Find the user details corresponding to the userId
//                 for (final userDetail in allUsersDetails) {
//                   if (userDetail.userId == userId) {
//                     userDetails = userDetail;
//                     break;
//                   }
//                 }
//                 if (userDetails == null) {
//                   // Handle the case when userDetails is null
//                   return const SizedBox.shrink(); // Or return a placeholder widget
//                 }
//                 // if (userDetails == null) {
//                 //   // Handle the case where userDetails is null, maybe return a placeholder widget
//                 //   return Container(); // Example placeholder
//                 // }
//                 return ListTile(
//                   visualDensity: const VisualDensity(vertical: -1),
//                   dense: true,
//                   title: Text(
//                     userDetails.userName,
//                     style: GoogleFonts.nunito(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: const Color(0xff161616),
//                     ),
//                   ),
//                   leading: CircleAvatar(
//                     backgroundImage: NetworkImage(
//                       userDetails.profilePic.isNotEmpty
//                           ? userDetails.profilePic
//                           : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
//                     ),
//                     radius: 20,
//                   ),
//                   subtitle: Text(
//                     'Lorem Ipsum',
//                     style: GoogleFonts.nunito(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w400,
//                       color: const Color(0xffA5A5A5),
//                     ),
//                   ),
//                   trailing: GestureDetector(
//                     onTap: () async {
//                       String currentUserId =
//                           FirebaseAuth.instance.currentUser!.uid;
//                       String userToUnfollowId = userId;
//
//                       // Call the unfollowUser method
//                       await ticketController.unfollowUser(
//                           currentUserId, userToUnfollowId);
//
//                       setState(() {});
//                     },
//                     child: Container(
//                       height: 3.5.h,
//                       width: 16.w,
//                       decoration: BoxDecoration(
//                         color: const Color(0xffd9e6f2),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Center(
//                         child: GradientText(
//                           text: "Following",
//                           gradient: const LinearGradient(
//                             colors: [
//                               Color(0xffFF0092),
//                               Color(0xff216DFD),
//                             ],
//                           ),
//                           style: GoogleFonts.inter(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// // class UserDetail {
// //   final String userId;
// //   final String email;
// //   final String userName;
// //   final String profilePic;
// //
// //   UserDetail(
// //       {required this.userId,
// //       required this.email,
// //       required this.userName,
// //       required this.profilePic});
// //
// //   factory UserDetail.fromDocumentSnapshot(DocumentSnapshot doc) {
// //     return UserDetail(
// //       userId: doc.id,
// //       email: doc['Email'].toString(),
// //       userName: doc['User Name'].toString(),
// //       profilePic: doc['profilePic'].toString(),
// //     );
// //   }
// // }
//
// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<List<UserDetail>> fetchAllUserDetails() async {
//     try {
//       final QuerySnapshot snapshot = await _firestore.collection('users').get();
//       return snapshot.docs
//           .map((doc) => UserDetail.fromDocumentSnapshot(doc))
//           .toList();
//     } catch (e) {
//       print("Error fetching user details: $e");
//       return [];
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserDetail> followingUsers = [];

  @override
  void initState() {
    super.initState();
    fetchFollowingUsers();
  }

  Future<void> fetchFollowingUsers() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Fetch following list from current user's document
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUserId).get();

      if (userDoc.exists && userDoc.data() != null) {
        List<dynamic> followingIds = userDoc['following'] ?? [];

        if (followingIds.isNotEmpty) {
          // Fetch user details of those being followed
          QuerySnapshot userSnapshots = await _firestore
              .collection('users')
              .where(FieldPath.documentId, whereIn: followingIds)
              .get();

          setState(() {
            followingUsers = userSnapshots.docs
                .map((doc) => UserDetail.fromDocumentSnapshot(doc))
                .toList();
          });
        }
      }
    } catch (e) {
      print("Error fetching following users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child:
              const Icon(Icons.arrow_back_ios, color: Colors.white, size: 19),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff025B8F),
        title: Text(
          'Following',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: followingUsers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: followingUsers.length,
              itemBuilder: (context, index) {
                final userDetails = followingUsers[index];

                return ListTile(
                  visualDensity: const VisualDensity(vertical: -1),
                  dense: true,
                  title: Text(
                    userDetails.userName,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff161616),
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userDetails.profilePic.isNotEmpty
                          ? userDetails.profilePic
                          : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                    ),
                    radius: 20,
                  ),
                  subtitle: Text(
                    'Lorem Ipsum',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffA5A5A5),
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      await unfollowUser(userDetails.userId);
                      fetchFollowingUsers(); // Refresh UI
                    },
                    child: Container(
                      height: 3.5.h,
                      width: 16.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffd9e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Following",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xffFF0092), Color(0xff216DFD)],
                              ).createShader(
                                  const Rect.fromLTWH(0, 0, 100, 20)),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> unfollowUser(String userToUnfollowId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.collection('users').doc(currentUserId).update({
      'following': FieldValue.arrayRemove([userToUnfollowId])
    });

    setState(() {
      followingUsers.removeWhere((user) => user.userId == userToUnfollowId);
    });
  }
}

class UserDetail {
  final String userId;
  final String userName;
  final String profilePic;

  UserDetail(
      {required this.userId, required this.userName, required this.profilePic});

  factory UserDetail.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserDetail(
      userId: doc.id,
      userName: doc['User Name'] ?? '',
      profilePic: doc['profilePic'] ?? '',
    );
  }
}
