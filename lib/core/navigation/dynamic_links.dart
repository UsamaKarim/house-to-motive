// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Firebase Dynamic Links',
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _initDynamicLinks();
//   }
//
//   void _initDynamicLinks() async {
//     FirebaseDynamicLinks.instance.onLink;
//
//     final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
//     final Uri? deepLink = data?.link;
//
//     if (deepLink != null) {
//       var isPost = deepLink.pathSegments.contains('post');
//       if (isPost) {
//         var postId = deepLink.queryParameters['postId'];
//         if (postId != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PostScreen(postId: postId),
//             ),
//           );
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final Uri dynamicLink = await createDynamicLink('yourPostId');
//             // Share the link or use it as needed
//             print(dynamicLink.toString());
//           },
//           child: Text('Generate Dynamic Link'),
//         ),
//       ),
//     );
//   }
// }
//
// class PostScreen extends StatelessWidget {
//   final String postId;
//
//   PostScreen({required this.postId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Post Screen'),
//       ),
//       body: Center(
//         child: Text('Post ID: $postId'),
//       ),
//     );
//   }
// }
//
// Future<Uri> createDynamicLink(String postId) async {
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'https://yourapp.page.link',
//     link: Uri.parse('https://yourapp.page.link/post?postId=$postId'),
//     androidParameters: const AndroidParameters(
//       packageName: 'com.example.yourapp',
//       minimumVersion: 0,
//     ),
//     iosParameters: const IOSParameters(
//       bundleId: 'com.example.yourapp',
//       minimumVersion: '0',
//     ),
//   );
//
//   final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
//   return shortLink.shortUrl;
// }
