class Singleton {
  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  factory Singleton() {
    return _instance;
  }

  double selectedLatitude = 0.0;
  double selectedLongitude = 0.0;

  void updateLocation(double lat, double lng) {
    selectedLatitude = lat;
    selectedLongitude = lng;
  }
}