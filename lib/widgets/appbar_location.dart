import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../views/Favourites/newFav.dart';
import '../views/screens/explore_screen.dart';
import '../views/screens/notification_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final placeApiController = Get.put(PlacesApi());
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xff025B8F),
      leading: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Image.asset('assets/pngs/htmlogo.png'),
      ),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/appbar/Vector@2x.png', height: 9, width: 9),
              const SizedBox(width: 5),
              const Text(
                'My Location',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  placeApiController.address.length > 35
                      ? placeApiController.address.substring(0, 35) + '..'
                      : placeApiController.address,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                Image.asset('assets/appbar/Vector1.png', height: 9, width: 9),
              ],
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.to(() => FavList());
          },
          child: SvgPicture.asset('assets/appbar/heart.svg'),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Get.to(() => const NotificationScreen());
          },
          child: SvgPicture.asset('assets/appbar/Notification.svg'),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
