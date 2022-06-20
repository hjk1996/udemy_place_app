import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longtitude;
  final String address;

  PlaceLocation(
      {required this.latitude,
      required this.longtitude,
      required this.address});
}

class Place {
  final String id;
  final String title;
  PlaceLocation? location;
  final File image;

  Place(
      {required this.id,
      required this.title,
      this.location,
      required this.image});
}
