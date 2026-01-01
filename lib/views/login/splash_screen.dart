import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_to_motive/controller/getchat_controller.dart';
import 'package:house_to_motive/views/screens/explore_screen.dart';
import 'package:house_to_motive/views/screens/navigation_bar/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/get_video_controller.dart';
import '../intro_screens/intro_screen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GetVideoController getVideoController =Get.put(GetVideoController());
  final GetChatSController getChatSController =Get.put(GetChatSController());
  final placeApiController = Get.put(PlacesApi());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // placeApiController.determinePosition();
   // getVideoController.fetchAndMarkLocations().then((value) => {
   // getVideoController.checkNearbyVideos().then((value) {
   //   Future.delayed(
   //     const Duration(seconds: 0), // Adjust the duration as needed
   //         () {
   //       nextScreen();
   //     },
   //   );
   // })
   //
   //
   // });
    nextScreen();
    // placeApiController.determinePosition();
  }

  nextScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool('isLogin') == false ||
        preferences.getBool('isLogin') == null) {
      Get.offAll(() => const IntroScreenOne());
    } else {
      Get.offAll(
        () => HomePage(),
        transition: Transition.downToUp,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/pngs/htmimage1.png',
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/svgs/splash-logo.png',
                width: 144,
                height: 144,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
