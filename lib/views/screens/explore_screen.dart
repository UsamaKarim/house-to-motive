import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_to_motive/controller/get_video_controller.dart';
import 'package:house_to_motive/data/singleton/singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/appbar_location.dart';
import 'package:http/http.dart' as http;

class ExploreScreen extends StatefulWidget {
  final String? selectedLocation;
  final Set<Marker> markers;
  const ExploreScreen({super.key, this.selectedLocation,required this.markers});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Future<void> _searchAndMarkLocation(String location) async {
    // Assuming PlacesApi has a method to search location by name and return coordinates
    LatLng coordinates =
    await placeApiController.searchLocationByName(location);
    setState(() {
      widget.markers.add(
        Marker(
          // Unique marker id
          markerId: MarkerId(location),
          // Use the coordinates of the location
          position: coordinates,
          infoWindow: InfoWindow(title: location),
          // Customize the marker icon if needed
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });

    // Optionally, move the camera to the new marker
    placeApiController.mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: coordinates,
          zoom: placeApiController.searchZoom, // Defined zoom level
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _initMap();
     // _fetchAndMarkLocations().then((value) => _initMap());

  }

  Future<void> _initMap() async {
    try {
      await placeApiController.determinePosition();
      if (widget.selectedLocation != null) {
        await _searchAndMarkLocation(widget.selectedLocation!);
      }
    } catch (e) {
      log("Error initializing map: $e");
    }
  }


  final placeApiController = Get.put(PlacesApi());

  @override
  Widget build(BuildContext context) {
    final GetVideoController getVideoController =Get.put(GetVideoController());

  return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Center(
                child: Stack(
                  children: [

                    SizedBox(
                      height: Get.height / 1.2,
                      width: Get.width,
                      child: GoogleMap(
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: false,
                        onMapCreated: placeApiController.onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: placeApiController.target,
                          zoom: placeApiController.defaultZoom,
                        ),
                        markers:getVideoController.markers,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) async {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return placeApiController
                              .getSuggestions(textEditingValue.text);
                        },
                        onSelected: (String selection) {
                          placeApiController.searchPlaces(selection);
                          placeApiController.storeRecentSearch(selection);
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              decoration: InputDecoration(
                                hintText: "Search what’s near me",
                                hintStyle: const TextStyle(
                                  fontFamily: 'ProximaNova',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff424B5A),
                                ),
                                isDense: true,
                                contentPadding:
                                const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/svgs/search-normal.svg',
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),


    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.selectedLocation;
  }
}

class PlacesApi extends GetxController {
  final TextEditingController eventLocationController = TextEditingController();
   GoogleMapController? mapController;
  final LatLng target = const LatLng(30.3753, 69.3451);
  final double defaultZoom = 4.0;
  final double searchZoom = 15.0; // Example location
  final key =
      'AIzaSyDotkOgJK6nWqbYMLFOuQQs8VNpyIOAmGw'; // Replace with your Google API Key

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

// Other code...

  void searchPlaces(String query) async {
    final String encodedQuery = Uri.encodeComponent(query);
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$encodedQuery&inputtype=textquery&fields=geometry&key=$key';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['candidates'] != null && result['candidates'].length > 0) {
          final location = result['candidates'][0]['geometry']['location'];

          Singleton().updateLocation(location['lat'], location['lng']);

          mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(location['lat'], location['lng']),
                zoom: searchZoom),
          ));
        }
      } else {
        if (kDebugMode) {
          print('Failed to load locations: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching places: $e');
      }
    }
  }

  Future<LatLng> searchLocationByName(String location) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$location&inputtype=textquery&fields=geometry&key=$key';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['candidates'].isNotEmpty) {
        final location = result['candidates'][0]['geometry']['location'];
        final double lat = location['lat'];
        final double lng = location['lng'];
        return LatLng(lat, lng);
      } else {
        throw Exception('Location not found');
      }
    } else {
      throw Exception('Failed to load location');
    }
  }

  RxList<String> recentSearches = <String>[].obs;

  void storeRecentSearch(String query) async {
    // Add the query to the recent searches list
    recentSearches.add(query);

    // Store the recent searches list in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentSearches', recentSearches.toList());
  }

  void removeRecentSearch(int index) async {
    // Remove the string at the specified index from recent searches list
    recentSearches.removeAt(index);

    // Store the updated recent searches list in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentSearches', recentSearches.toList());
  }

  Future<void> getRecentSearchesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedRecentSearches =
        prefs.getStringList('recentSearches') ?? [];
    recentSearches.assignAll(savedRecentSearches);
  }

  Future<List<String>> getSuggestions(String query) async {
    final String encodedQuery = Uri.encodeComponent(query);
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$encodedQuery&key=$key';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['predictions'] != null) {
          return List<String>.from(result['predictions']
              .map((prediction) => prediction['description']));
        }
        return [];
      } else {
        if (kDebugMode) {
          print('Failed to load suggestions: ${response.body}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while fetching suggestions: $e');
      }
      return [];
    }
  }

  // GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(0.0, 0.0);
  final double _zoomLevel = 17.0; // Higher value for closer zoom
  String address = "";



  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled, prompt the user to enable them.
      bool enableService = await Geolocator.openLocationSettings();
      if (!enableService) {
        // The user declined to enable location services.
        throw 'Location services are disabled.';
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the current position.
    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    _getAddressFromLatLng(position);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition,
          zoom: _zoomLevel, // Set the zoom level here
        ),
      ),
    );
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      address =
      "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
