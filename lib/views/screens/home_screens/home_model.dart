import 'package:flutter/cupertino.dart';

List<UserData> userDataList = [
  UserData(
      image:
      'https://e0.pxfuel.com/wallpapers/614/775/desktop-wallpaper-anime-pfp-sky-art-anime-dp-anime-dp-anime-boy-profile.jpg',
      username: 'Jane James',
      miles: 13.2),
  UserData(
      image:
      'https://e1.pxfuel.com/desktop-wallpaper/732/405/desktop-wallpaper-cartoon-dp-boy-for-whatsapp-handsome-boy-cartoon.jpg',
      username: 'The Club',
      miles: 10.3),
  UserData(
      image:
      'https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
      username: 'Sommersest..',
      miles: 12.2),
  UserData(
      image:
      'https://e0.pxfuel.com/wallpapers/932/376/desktop-wallpaper-stylish-boys-cool-d-profile-pics-for-facebook-whatsapp-pretty-boys.jpg',
      username: 'China Town',
      miles: 14.5),
  UserData(
      image:
      'https://e1.pxfuel.com/desktop-wallpaper/473/806/desktop-wallpaper-cool-boy-for-facebook-profile-anime-profile-whatsapp.jpg',
      username: 'We Jam',
      miles: 7.4),
  UserData(
      image:
      'https://e0.pxfuel.com/wallpapers/614/775/desktop-wallpaper-anime-pfp-sky-art-anime-dp-anime-dp-anime-boy-profile.jpg',
      username: 'Jane James',
      miles: 13.2),
];

List<LatestVideos> latestVideoUrls = [
  LatestVideos(
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQgDGes8_dmRN0QisbJN1XoN1SuqJLcj6jRQ&usqp=CAU',
      videoUrl:
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'),
  LatestVideos(
      image:
      'https://wallpapers.com/images/hd/beautiful-flowers-pictures-1z4wk44o2a1dshai.jpg',
      videoUrl:
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
];

List<RandomVideos> randomVideosUrls = [
  RandomVideos(
      image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQgDGes8_dmRN0QisbJN1XoN1SuqJLcj6jRQ&usqp=CAU',
      videoUrl:
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'),
  RandomVideos(
    image:
    'https://wallpapers.com/images/hd/beautiful-flowers-pictures-1z4wk44o2a1dshai.jpg',
    videoUrl:
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ),
];

final List<Map<String, String>> itemList = [
  {
    'title': 'Item 1',
    'image': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D',
    'description': 'Description for Item 1',
  },
  {
    'title': 'Item 2',
    'image': 'https://elmomento.pk/wp-content/uploads/2023/07/elmomento-islamabad-ambiance-min.jpg',
    'description': 'Description for Item 2',
  },
  {
    'title': 'Item 3',
    'image': 'https://d4t7t8y8xqo0t.cloudfront.net/app/eazymedia/restaurant%2F672810%2Frestaurant120210115104413.jpg',
    'description': 'Description for Item 2',
  },
  {
    'title': 'Item 4',
    'image': 'https://www.ft.com/__origami/service/image/v2/images/raw/ftcms%3A1f658361-23be-4b7e-bb0b-dbeb5bab1acb?source=next-article&fit=scale-down&quality=highest&width=1440&dpr=1',
    'description': 'Description for Item 2',
  },
  {
    'title': 'Item 5',
    'image': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D',
    'description': 'Description for Item 2',
  },
  // Add more items as needed
];

List<FoodNearby> foodnearby = [
  FoodNearby(
      image:
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D',
      city: 'Sanizo Resturent',
      price: '34',
      mile: '5',
      location: 'DHA phase 5',
      rating: '91 (5.0)'),
  FoodNearby(
      image:
      'https://elmomento.pk/wp-content/uploads/2023/07/elmomento-islamabad-ambiance-min.jpg',
      city: 'Babu Tikka',
      price: '54',
      mile: '5.7',
      location: 'f4 near park view',
      rating: '91 (5.0)'),
  FoodNearby(
      image:
      'https://d4t7t8y8xqo0t.cloudfront.net/app/eazymedia/restaurant%2F672810%2Frestaurant120210115104413.jpg',
      city: 'Hen n bun',
      price: '25',
      mile: '8.9',
      location: 'Barkat market',
      rating: '91 (5.0)'),
  FoodNearby(
      image:
      'https://www.ft.com/__origami/service/image/v2/images/raw/ftcms%3A1f658361-23be-4b7e-bb0b-dbeb5bab1acb?source=next-article&fit=scale-down&quality=highest&width=1440&dpr=1',
      city: 'Yasir broast',
      price: '34',
      mile: '5',
      location: 'Ali town Thokar niaz baig',
      rating: '91 (5.0)'),
  FoodNearby(
      image:
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D',
      city: 'Sanizo',
      price: '34',
      mile: '5',
      location: 'DHA phase 5',
      rating: '91 (5.0)'),
];

class UserData {
  final String image;
  final String username;
  final double miles;

  UserData({
    required this.image,
    required this.username,
    required this.miles,
  });
}

class LatestVideos {
  final String image;
  final String videoUrl;
  LatestVideos({
    required this.image,
    required this.videoUrl,
  });
}

class RandomVideos {
  final String image;
  final String videoUrl;
  RandomVideos({
    required this.image,
    required this.videoUrl,
  });
}

class FoodNearby {
  final String image;
  final String city;
  final String price;
  final String mile;
  final String location;
  final String rating;

  FoodNearby({
    required this.image,
    required this.city,
    required this.price,
    required this.mile,
    required this.location,
    required this.rating,
  });
}

class GradientText extends StatelessWidget {
  const GradientText({
    Key? key,
    required this.text,
    this.style,
    required this.gradient,
  }) : super(key: key);
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
