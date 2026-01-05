import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_to_motive/views/screens/custom_marker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:ui' as ui;
import 'package:geocoding/geocoding.dart';
import '../views/screens/video_screen.dart';

class GetVideoController extends GetxController {
  final Set<Marker> markers = <Marker>{}.obs;
  final RxList<String> videoUrls = <String>[].obs;
  final RxList<String> userIdsList1 = <String>[].obs;
  final RxList<String> videoIdsList1 = <String>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<BitmapDescriptor> getBitmapDescriptorFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Uint8List bytes = response.bodyBytes;

    final ui.Codec codec = await ui.instantiateImageCodec(bytes,
        targetWidth: 100, targetHeight: 150);
    final ui.FrameInfo fi = await codec.getNextFrame();

    final ui.Image image = fi.image;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..isAntiAlias = true;

    final RRect clipRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 100.0, 150.0),
      const Radius.circular(20.0),
    );
    canvas.clipRRect(clipRect);
    canvas.drawImage(image, Offset.zero, paint);

    final ui.Image finalImage =
        await pictureRecorder.endRecording().toImage(100, 150);
    final ByteData? byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List finalBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(finalBytes);
  }

  Future<void> fetchAndMarkLocations() async {
    final videoCollection = firestore.collection('videos');
    final querySnapshot = await videoCollection.get();

    List<Future<void>> futures = [];

    for (var doc in querySnapshot.docs) {
      futures.add(_processDocument(doc));
    }

    await Future.wait(futures);
  }

  Future<void> _processDocument(DocumentSnapshot doc) async {
    final String address = doc['location'];
    final String imageURL = doc['thumbnailUrl'];
    final String videoURL = doc['videoUrl'];
    final String userId = doc['userId'];
    final String docId = doc.id;
    log('location $address');
    log('imageURL $imageURL');
    log('videoURL $videoURL');

    try {
      final List<Location> locations = await locationFromAddress(address);
      final BitmapDescriptor customIcon =
          await getBitmapDescriptorFromUrl(imageURL);
      final Location location = locations.first;

      final marker = Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(location.latitude, location.longitude),
        icon: customIcon,
        onTap: () {
          Get.to(
            () => VideoScreen(
              videoUrls: videoUrls,
              initialIndex: videoUrls.indexOf(videoURL),
              videoUserIdList: userIdsList1,
              title: 'title',
              videoIdList: videoIdsList1,
              userId: userId,
            ),
          );
        },
      );

      markers.add(marker);
      videoUrls.add(videoURL);
      userIdsList1.add(userId);
      videoIdsList1.add(docId);
    } catch (e) {
      log('Error processing document $doc: $e');
    }
  }

  //check follow or not
  RxBool isFollowing = false.obs;
  Future<void> checkFollowingStatus(String ticketUid) async {
    // Fetch the current user's document from Firestore
    DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // Check if the current user is following the other user
    bool isAlreadyFollowing = currentUserDoc['following'] != null &&
        currentUserDoc['following'].contains(ticketUid);

    isFollowing = isAlreadyFollowing.obs;
  }

  //Check Nearby Videos
  var nearByVideos = <videoInfo>[].obs;
  var distanceList = [].obs;
  var addressList = [].obs;
  var isLoading = false.obs;
  RxList<String> videoUrlsNearByLocation = <String>[].obs;
  RxList<String> videoUserIdsList = <String>[].obs;
  RxList<String> thumbnailList = <String>[].obs;
  RxList<String> idList = <String>[].obs;
  RxString userId = ''.obs;

  Future<void> checkNearbyVideos() async {
    try {
      isLoading.value = true;
      nearByVideos.clear();
      kilometersList.clear();
      distanceList.clear();
      idList.clear();
      videoUrlsNearByLocation.clear();
      videoUserIdsList.clear();
      thumbnailList.clear();

      Position currentPosition = await _determinePosition();
      double userLat = currentPosition.latitude;
      double userLon = currentPosition.longitude;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('videos').get();

      // Process videos in parallel batches
      const int batchSize = 10; // Process 10 videos at a time
      List<videoInfo> tempVideos = [];
      List<double> tempDistances = [];

      // Split documents into batches
      List<List<QueryDocumentSnapshot>> batches = [];
      for (int i = 0; i < querySnapshot.docs.length; i += batchSize) {
        batches.add(
          querySnapshot.docs.skip(i).take(batchSize).toList(),
        );
      }

      // Process each batch in parallel
      for (var batch in batches) {
        List<Future<void>> batchFutures = [];

        for (var video in batch) {
          batchFutures.add(_processVideo(
            video,
            userLat,
            userLon,
            tempVideos,
            tempDistances,
          ));
        }

        // Wait for all videos in the batch to be processed
        await Future.wait(batchFutures);
      }

      // Sort the videos based on distance in ascending order
      List<MapEntry<videoInfo, double>> sortedVideos = List.generate(
        tempVideos.length,
        (index) => MapEntry(tempVideos[index], tempDistances[index]),
      );

      sortedVideos.sort((a, b) => a.value.compareTo(b.value));

      // Update with sorted data
      for (var entry in sortedVideos) {
        nearByVideos.add(entry.key);
        kilometersList.add(entry.value);
        distanceList.add(entry.value);
      }
    } catch (e) {
      log("Error in checkNearbyVideos: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _processVideo(
    QueryDocumentSnapshot video,
    double userLat,
    double userLon,
    List<videoInfo> tempVideos,
    List<double> tempDistances,
  ) async {
    try {
      double videoLat = video.get('latitude');
      double videoLon = video.get('longitude');

      // Calculate distance using Geolocator (returns meters, so convert to km)
      double roadDistance =
          Geolocator.distanceBetween(userLat, userLon, videoLat, videoLon) /
              1000;

      if (roadDistance <= 15 && !idList.contains(video.id)) {
        // Create a videoInfo object
        videoInfo videoData = videoInfo(
          userId: video.get('userId'),
          location: video.get('location'),
          videoUrl: video.get('videoUrl'),
          thumbnailUrl: video.get('thumbnailUrl'),
          userName: video.get('userName'),
        );

        // Add video and distance to temporary lists
        tempVideos.add(videoData);
        tempDistances.add(roadDistance);

        // Store additional information
        idList.add(video.id);
        videoUrlsNearByLocation.add(video.get('videoUrl'));
        videoUserIdsList.add(video.get('userId'));
        thumbnailList.add(video.get('thumbnailUrl'));
      }
    } catch (e) {
      log("Error processing video: $e");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  //get user Videos
  RxList<Map<String, dynamic>> userVideos = <Map<String, dynamic>>[].obs;
  RxList<String> videoIdList = <String>[].obs;
  RxList<String> videoUserIdList = <String>[].obs;
  RxList<String> videoUrlList = <String>[].obs;

  Future<void> getUserVideos(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('videos').get();

    final List<Map<String, dynamic>> filteredVideos = userSnapshot.docs
        .map((doc) => doc.data())
        .where((data) => data['userId'] == userId)
        .toList();

    userVideos.value = filteredVideos; // Use .value to set the value of RxList

    // Clear the lists before adding new items to avoid duplication
    videoIdList.clear();
    videoUserIdList.clear();
    videoUrlList.clear();

    for (var doc in userSnapshot.docs) {
      final data = doc.data();
      if (data['userId'] == userId) {
        videoIdList.add(doc.id); // Store document ID
        videoUserIdList.add(data['userId']); // Store user ID
        videoUrlList.add(data[
            'videoUrl']); // Store video URL (assuming 'videoUrl' is the field name)
        log("Document ID: ${doc.id}, User ID: ${data['userId']}, Video URL: ${data['videoUrl']}");
      }
    }
  }

  RxList<double> kilometersList = <double>[].obs;

  void convertDistanceToKilometers() {
    for (int i = 0; i < distanceList.length; i++) {
      log("Distance in kilometers: $kilometersList");
      double kilometers =
          distanceList[i] / 1000; // Convert meters to kilometers
      if (!kilometersList.contains(kilometers)) {
        kilometersList.add(kilometers);
      }
    }
  }

  Future<double> getRoadDistance(
      double lat1, double lon1, double lat2, double lon2) async {
    const String apiKey = "AIzaSyDotkOgJK6nWqbYMLFOuQQs8VNpyIOAmGw";
    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$lat1,$lon1&destinations=$lat2,$lon2&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var distanceInMeters =
          jsonResponse["rows"][0]["elements"][0]["distance"]["value"];
      return distanceInMeters / 1000; // Convert to km
    } else {
      throw Exception("Failed to fetch road distance");
    }
  }
}
