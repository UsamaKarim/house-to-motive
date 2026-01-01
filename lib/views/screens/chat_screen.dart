import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_to_motive/controller/getchat_controller.dart';
import 'package:house_to_motive/views/screens/chatRoom.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/event_controller.dart';
import '../../widgets/appbar_location.dart';
import '../../widgets/loginbutton.dart';
import '../login/loginwith_email.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TicketController ticketController = Get.put(TicketController());

  final GetChatSController getChatSController = Get.put(GetChatSController());

  bool isChatLoaded = false;
  var isGuestLogin = false;

  Future<bool> checkGuestMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool('isGuest') ?? false;
    return result; // Return bool, defaulting to false if no value
  }

  _checkGuestMode() async {
    bool guestStatus = await checkGuestMode();  // Await the async method
    setState(() {
      isGuestLogin = guestStatus;
    });

    if (!isGuestLogin) {
      getChatSController.activeChat.clear();
      getChatSController.nameList.clear();
      getChatSController.lastMessageTimeList.clear();
      getChatSController.lastMessageList.clear();

      getChatSController.getUsers();
      getChatSController.fetchUserData();
      setState(() {
        isChatLoaded = false;
      });

      getChatSController.getActiveChatUser().then((value) {
        getChatSController.checkTodayMessages();
        getChatSController.recentChat();
        setState(() {
          isChatLoaded = true;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkGuestMode();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: isGuestLogin ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Please Login to continue', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              title: "Login",
              ontap: () {
                Get.offAll(() => LoginWithEmailScreen());
              },
            ),
          ),
        ],
      ) : isChatLoaded
          ? SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Obx(
              () => Column(
                children: [
                  // SizedBox(height: 25)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Recent Chats',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: const Color(0xff025B8F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  getChatSController.nameList.isEmpty
                      ? const Text('There is No Chat Available')
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.5.h),
                          height: screenHeight * 0.16,
                          child: Row(
                            // Wrap ListView.builder with Row
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: getChatSController.nameList.length,
                                itemBuilder: (context, index) {
                                  DateTime dateTime = DateTime.parse(
                                      getChatSController
                                          .lastMessageTimeList[index]);
                                  String dayOfMonth =
                                      DateFormat('HH').format(dateTime);
                                  return getChatSController
                                          .recentLastMessageList
                                          .contains(dayOfMonth)
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => ChatPage(
                                                name: getChatSController
                                                    .nameList[index],
                                                receiverId: getChatSController
                                                    .activeIdsList[
                                                index],
                                                receiverEmail:
                                                    getChatSController
                                                        .activeIdsList[index],
                                                chatRoomId: getChatSController
                                                    .chatRoomId(
                                                        getChatSController
                                                                .activeIdsList[
                                                            index],
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid),
                                                pic: getChatSController
                                                    .picList[index],
                                              ),
                                            );
                                          },
                                          child: getChatSController
                                                  .recentLastMessageList
                                                  .contains(dayOfMonth)
                                              ? Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          getChatSController
                                                                  .picList[
                                                                      index]
                                                                  .isEmpty
                                                              ? 'https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg'
                                                              : getChatSController
                                                                      .picList[
                                                                  index],
                                                          scale: 1.0),
                                                      maxRadius: 5.h,
                                                    ),
                                                    SizedBox(height: 0.2.h),
                                                    Text(
                                                      getChatSController
                                                          .nameList[index],
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xff161616),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                        )
                                      : const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Today Messages',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: const Color(0xff025B8F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: .5.h),
                  getChatSController.nameList.isEmpty
                      ? const Text('There is No Chat Available')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: getChatSController.nameList.length,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(
                                getChatSController.lastMessageTimeList[index]);
                            String dayOfMonth =
                                DateFormat('d').format(dateTime);
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ChatPage(
                                    name: getChatSController.nameList[index],
                                    receiverEmail:
                                        getChatSController.activeIdsList[index],
                                    receiverId: getChatSController
                                        .activeIdsList[
                                    index],
                                    chatRoomId: getChatSController.chatRoomId(
                                        getChatSController.activeIdsList[index],
                                        FirebaseAuth.instance.currentUser!.uid),
                                    pic: getChatSController.picList[index],
                                  ),
                                );
                              },
                              child: Slidable(
                                // key: const ValueKey(6),

                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.13,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.bottomSheet(
                                            const BottomSheetDeletDialog());
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color(0xffFFE7E5),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                              'assets/svgs/Trash.svg'),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                child: getChatSController.todayLastMessageList
                                        .contains(dayOfMonth)
                                    ? Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  getChatSController
                                                          .picList[index]
                                                          .isEmpty
                                                      ? 'https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg'
                                                      : getChatSController
                                                          .picList[index],
                                                  scale: 1.0),
                                            ),
                                            title: Text(
                                              getChatSController
                                                  .nameList[index],
                                              style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff161616),
                                              ),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Image.asset(
                                                    'assets/pngs/export.png'),
                                                const SizedBox(width: 8),
                                                Text(
                                                  getChatSController
                                                              .lastMessageList[
                                                                  index]
                                                              .length >
                                                          8
                                                      ? '${getChatSController.lastMessageList[index].substring(0, 8)}...'
                                                      : getChatSController
                                                              .lastMessageList[
                                                          index],
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xff575757),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  DateFormat('HH:mm').format(
                                                      DateTime.parse(
                                                          getChatSController
                                                                  .lastMessageTimeList[
                                                              index])),
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xff575757),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            );
                          },
                        ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Yesterday',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: const Color(0xff025B8F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  getChatSController.nameList.isEmpty
                      ? const Text('There is No Chat Available')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics:  const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: getChatSController.nameList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                                 Get.to(
                                  () => ChatPage(
                                    name: getChatSController.nameList[index] ,
                                    receiverEmail: getChatSController.activeIdsList[index],
                                    receiverId: getChatSController
                                        .activeIdsList[
                                    index],
                                    chatRoomId: FirebaseAuth.instance.currentUser != null
                                        ? getChatSController.chatRoomId(
                                        getChatSController.activeIdsList[index],
                                        FirebaseAuth.instance.currentUser!.uid)
                                        : "Unknown Chat Room ID",
                                    pic: getChatSController.picList[index] ,
                                  ),

                                );
                              },
                              child: Slidable(
                                // key: const ValueKey(6),

                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.13,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.bottomSheet(
                                            const BottomSheetDeletDialog());
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color(0xffFFE7E5),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                              'assets/svgs/Trash.svg'),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            getChatSController
                                                    .picList[index].isEmpty
                                                ? 'https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg'
                                                : getChatSController
                                                    .picList[index],
                                            scale: 1.0),
                                      ),
                                      title: Text(
                                        getChatSController.nameList[index],
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff161616),
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Image.asset('assets/pngs/export.png'),
                                          const SizedBox(width: 8),
                                          Text(
                                            getChatSController
                                                        .lastMessageList[index]
                                                        .length >
                                                    8
                                                ? '${getChatSController.lastMessageList[index].substring(0, 8)}...'
                                                : getChatSController
                                                    .lastMessageList[index],
                                            style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff575757),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            DateFormat('HH:mm').format(DateTime
                                                .parse(getChatSController
                                                        .lastMessageTimeList[
                                                    index])),
                                            style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff575757),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  SizedBox(height: 10.5.h),
                ],
              ),
            ),
          ),
        ),
      )
          : Center(child: CircularProgressIndicator(),),
    );
  }
}

class BottomSheetDeletDialog extends StatelessWidget {
  const BottomSheetDeletDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Set the background color to transparent
      child: Container(
        height: 35.h,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.px),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svgs/akar-icons_chat-error.svg'),
              SizedBox(height: 1.7.h),
              Text(
                'Delete Ariana Conversation?',
                style: GoogleFonts.inter(
                    color: const Color(0xff010101),
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 1.7.h),
              Text(
                textAlign: TextAlign.center,
                'Do you really want to delete this conversation?',
                style: GoogleFonts.inter(
                  color: const Color(0xff424B5A),
                  fontSize: 14.px,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 5.5.h,
                      width: 20.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff090808),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color(0xff090808),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 5.5.h,
                    width: 20.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xff025B8F),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(() => HomePage());
                      },
                      child: Center(
                        child: Text(
                          'Delete',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
