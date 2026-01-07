import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/views/screens/home_screens/home_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controller/event_controller.dart';
import 'chatRoom.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TicketController ticketController = Get.put(TicketController());
  final FirestoreService _firestoreService = FirestoreService();
  List<UserDetail> allUsersDetails = [];
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    print("Follower List: ${ticketController.followersList.length}");
  }

  void fetchUserData() async {
    allUsersDetails = await _firestoreService.fetchAllUserDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ticketController.fetchFollowersList(
      FirebaseAuth.instance.currentUser?.uid ?? '',
    );
    _firestoreService.fetchAllUserDetails();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 19,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff025B8F),
        title: Text(
          'Followers',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _firestoreService.fetchAllUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), // Show circular progress indicator
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Show error message
            );
          } else {
            // Data has been loaded successfully, build the ListView
            return ListView.builder(
              shrinkWrap: true,
              itemCount: ticketController.followersList.length,
              itemBuilder: (context, index) {
                final String userId = ticketController.followersList[index];
                UserDetail? userDetails;

                // Find the user details corresponding to the userId
                for (final userDetail in allUsersDetails) {
                  if (userDetail.userId == userId) {
                    userDetails = userDetail;
                    break;
                  }
                }

                if (userDetails == null) {
                  // Handle the case when userDetails is null
                  return const SizedBox.shrink(); // Or return a placeholder widget
                }
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      ChatPage(
                        name: userDetails!.userName,
                        receiverEmail: userDetails.userId,
                        receiverId: userDetails.userId,
                        chatRoomId: chatRoomId(
                          userDetails.userId,
                          FirebaseAuth.instance.currentUser?.uid ?? '',
                        ),
                        pic: userDetails.profilePic,
                      ),
                    );
                  },
                  child: ListTile(
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
                        String currentUserId =
                            FirebaseAuth.instance.currentUser?.uid ?? '';
                        String followerUserId = userId;

                        await ticketController.removeFollower(
                          currentUserId,
                          followerUserId,
                        );

                        setState(() {});
                      },
                      child: Container(
                        height: 3.5.h,
                        width: 16.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffd9e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: GradientText(
                            text: "Remove",
                            gradient: const LinearGradient(
                              colors: [Color(0xffFF0092), Color(0xff216DFD)],
                            ),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class UserDetail {
  final String userId;
  final String email;
  final String userName;
  final String profilePic;

  UserDetail({
    required this.userId,
    required this.email,
    required this.userName,
    required this.profilePic,
  });

  factory UserDetail.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserDetail(
      userId: doc.id,
      email: doc['Email'].toString(),
      userName: doc['User Name'].toString(),
      profilePic: doc['profilePic'].toString(),
    );
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
      print("Error fetching user details: $e");
      return [];
    }
  }
}
