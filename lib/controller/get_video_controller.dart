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
import '../views/screens/video_screen.dart';
import '../utils/debouncer.dart';

class GetVideoController extends GetxController {
  final Set<Marker> markers = <Marker>{}.obs;
  final RxList<String> videoUrls = <String>[].obs;
  final RxList<String> userIdsList1 = <String>[].obs;
  final RxList<String> videoIdsList1 = <String>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Initialization state tracking
  final RxBool isInitialized = false.obs;
  final RxBool isLoadingLocations = false.obs;
  Future<BitmapDescriptor> getBitmapDescriptorFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Uint8List bytes = response.bodyBytes;

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 100,
      targetHeight: 150,
    );
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

    final ui.Image finalImage = await pictureRecorder.endRecording().toImage(
      100,
      150,
    );
    final ByteData? byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List finalBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(finalBytes);
  }

  Future<void> fetchAndMarkLocations() async {
    try {
      isLoadingLocations.value = true;
      isInitialized.value = false;

      // Clear existing data to prevent duplicates
      markers.clear();
      videoUrls.clear();
      userIdsList1.clear();
      videoIdsList1.clear();

      // Track processed document IDs to prevent duplicates within the same fetch
      final Set<String> processedIds = <String>{};

      final videoCollection = firestore.collection('videos');
      final querySnapshot = await videoCollection.get();

      List<Future<void>> futures = [];

      for (var doc in querySnapshot.docs) {
        // Skip if already processed (shouldn't happen in same fetch, but safety check)
        if (!processedIds.contains(doc.id)) {
          futures.add(_processDocument(doc, processedIds));
        }
      }

      await Future.wait(futures);

      // Mark as initialized only if we successfully processed at least some data
      isInitialized.value = true;
      log(
        'Successfully initialized ${markers.length} markers and ${videoUrls.length} videos',
        name: 'fetchAndMarkLocations',
      );
    } catch (e, s) {
      // On error, ensure state is consistent - data is cleared, not partially initialized
      log(
        'Error in fetchAndMarkLocations: $e',
        name: 'fetchAndMarkLocations',
        error: e,
        stackTrace: s,
      );
      isInitialized.value = false;
      // Data is already cleared, so state is consistent (empty but valid)
    } finally {
      isLoadingLocations.value = false;
    }
  }

  Future<void> _processDocument(
    DocumentSnapshot doc,
    Set<String> processedIds,
  ) async {
    final String docId = doc.id;

    // Check if this document has already been processed (deduplication)
    if (processedIds.contains(docId) || videoIdsList1.contains(docId)) {
      log('Skipping duplicate document: $docId', name: 'fetchAndMarkLocations');
      return;
    }

    try {
      // Validate required fields exist
      if (!doc.exists || doc.data() == null) {
        log(
          'Document $docId does not exist or has no data',
          name: 'fetchAndMarkLocations',
        );
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      final String? address = data['location'] as String?;
      final String? imageURL = data['thumbnailUrl'] as String?;
      final String? videoURL = data['videoUrl'] as String?;
      final String? userId = data['userId'] as String?;
      final dynamic latitudeValue = data['latitude'];
      final dynamic longitudeValue = data['longitude'];

      // Validate required fields
      if (imageURL == null ||
          videoURL == null ||
          userId == null ||
          latitudeValue == null ||
          longitudeValue == null) {
        log(
          'Missing required fields for document $docId',
          name: 'fetchAndMarkLocations',
        );
        return;
      }

      final double? latitude =
          (latitudeValue is num) ? latitudeValue.toDouble() : null;
      final double? longitude =
          (longitudeValue is num) ? longitudeValue.toDouble() : null;

      if (latitude == null || longitude == null) {
        log(
          'Invalid latitude or longitude for document $docId',
          name: 'fetchAndMarkLocations',
        );
        return;
      }

      log('location $address');
      log('imageURL $imageURL');
      log('videoURL $videoURL');

      // Check for duplicate marker before adding
      final markerId = MarkerId(docId);
      final markerExists = markers.any((m) => m.markerId == markerId);

      if (!markerExists) {
        // final List<Location> locations = await locationFromAddress(address);
        final BitmapDescriptor customIcon = await getBitmapDescriptorFromUrl(
          imageURL,
        );
        // final Location location = locations.first;
        final marker = Marker(
          markerId: markerId,
          position: LatLng(latitude, longitude),
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
      }

      // Add to lists only if not already present (additional safety check)
      if (!videoIdsList1.contains(docId)) {
        videoUrls.add(videoURL);
        userIdsList1.add(userId);
        videoIdsList1.add(docId);
        processedIds.add(docId); // Mark as processed
      }
    } catch (e, s) {
      // Log error but continue processing other documents
      log(
        'Error processing document $docId: $e',
        name: 'fetchAndMarkLocations',
        error: e,
        stackTrace: s,
      );
      // Don't rethrow - allow other documents to be processed
    }
  }

  //check follow or not
  RxBool isFollowing = false.obs;
  Future<void> checkFollowingStatus(String ticketUid) async {
    // Fetch the current user's document from Firestore
    DocumentSnapshot currentUserDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
    log('$currentUserDoc', name: 'checkFollowingStatus');

    // Check if the current user is following the other user
    bool isAlreadyFollowing =
        (currentUserDoc.data() as Map<String, dynamic>)['following'] != null &&
        (currentUserDoc.data() as Map<String, dynamic>)['following'].contains(
          ticketUid,
        );

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
      // Temporary lists to store data that will be sorted together
      List<String> tempIds = [];
      List<String> tempVideoUrls = [];
      List<String> tempUserIds = [];
      List<String> tempThumbnails = [];

      // Split documents into batches
      List<List<QueryDocumentSnapshot>> batches = [];
      for (int i = 0; i < querySnapshot.docs.length; i += batchSize) {
        batches.add(querySnapshot.docs.skip(i).take(batchSize).toList());
      }

      // Process each batch in parallel
      for (var batch in batches) {
        List<Future<void>> batchFutures = [];

        for (var video in batch) {
          batchFutures.add(
            _processVideo(
              video,
              userLat,
              userLon,
              tempVideos,
              tempDistances,
              tempIds,
              tempVideoUrls,
              tempUserIds,
              tempThumbnails,
            ),
          );
        }

        // Wait for all videos in the batch to be processed
        await Future.wait(batchFutures);
      }

      // Sort the videos based on distance in ascending order
      List<MapEntry<int, double>> indexedDistances = List.generate(
        tempVideos.length,
        (index) => MapEntry(index, tempDistances[index]),
      );

      indexedDistances.sort((a, b) => a.value.compareTo(b.value));

      // Update all lists with sorted data in the same order
      for (var entry in indexedDistances) {
        int sortedIndex = entry.key;
        nearByVideos.add(tempVideos[sortedIndex]);
        kilometersList.add(entry.value);
        distanceList.add(entry.value);
        // Update all lists in sorted order
        idList.add(tempIds[sortedIndex]);
        videoUrlsNearByLocation.add(tempVideoUrls[sortedIndex]);
        videoUserIdsList.add(tempUserIds[sortedIndex]);
        thumbnailList.add(tempThumbnails[sortedIndex]);
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
    List<String> tempIds,
    List<String> tempVideoUrls,
    List<String> tempUserIds,
    List<String> tempThumbnails,
  ) async {
    try {
      double videoLat = video.get('latitude');
      double videoLon = video.get('longitude');

      // Calculate distance using Geolocator (returns meters, so convert to km)
      double roadDistance =
          Geolocator.distanceBetween(userLat, userLon, videoLat, videoLon) /
          1000;

      if (roadDistance <= 15 && !tempIds.contains(video.id)) {
        // Create a videoInfo object
        videoInfo videoData = videoInfo(
          userId: video.get('userId'),
          location: video.get('location'),
          videoUrl: video.get('videoUrl'),
          thumbnailUrl: video.get('thumbnailUrl'),
          userName: video.get('userName'),
        );

        // Add video and distance to temporary lists (will be sorted later)
        tempVideos.add(videoData);
        tempDistances.add(roadDistance);
        tempIds.add(video.id);
        tempVideoUrls.add(video.get('videoUrl'));
        tempUserIds.add(video.get('userId'));
        tempThumbnails.add(video.get('thumbnailUrl'));
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
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  //get user Videos
  RxList<Map<String, dynamic>> userVideos = <Map<String, dynamic>>[].obs;
  RxList<String> videoIdList = <String>[].obs;
  RxList<String> videoUserIdList = <String>[].obs;
  RxList<String> videoUrlList = <String>[].obs;

  Future<void> getUserVideos(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('videos').get();

    final List<Map<String, dynamic>> filteredVideos =
        userSnapshot.docs
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
        videoUrlList.add(
          data['videoUrl'],
        ); // Store video URL (assuming 'videoUrl' is the field name)
        log(
          "Document ID: ${doc.id}, User ID: ${data['userId']}, Video URL: ${data['videoUrl']}",
        );
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

  final Debouncer _getRoadDistanceDebouncer = Debouncer();
  Completer<double>? _roadDistanceCompleter;

  Future<double> getRoadDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) async {
    // Create new completer for this request
    final completer = Completer<double>();
    _roadDistanceCompleter = completer;

    // Capture parameters and completer in closure to avoid race conditions
    _getRoadDistanceDebouncer.run(() async {
      try {
        const String apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
        String url =
            "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$lat1,$lon1&destinations=$lat2,$lon2&key=$apiKey";

        final response = await http.get(Uri.parse(url));
        log('$response', name: 'getRoadDistance');

        // Check if this completer is still the current one and not completed
        if (completer != _roadDistanceCompleter || completer.isCompleted) {
          return;
        }

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          var distanceInMeters =
              jsonResponse["rows"][0]["elements"][0]["distance"]["value"];
          final result = distanceInMeters / 1000; // Convert to km
          if (!completer.isCompleted) {
            completer.complete(result);
          }
        } else {
          if (!completer.isCompleted) {
            completer.completeError(Exception("Failed to fetch road distance"));
          }
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    });

    return completer.future;
  }

  @override
  void onClose() {
    _getRoadDistanceDebouncer.dispose();
    super.onClose();
  }
}
