import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../helpers/db_helpers.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation location) async {
    final address = await LocationHelper.getPlaceAdress(
        location.latitude, location.longtitude);

    final updatedLocation = PlaceLocation(
        latitude: location.latitude,
        longtitude: location.longtitude,
        address: address);
    final newPlace = Place(
        id: DateTime.now().toIso8601String(),
        title: title,
        location: location,
        image: image);

    _items.add(newPlace);
    notifyListeners();
    await DBHelper.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longtitude,
      'address': address
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData("places");
    _items = dataList
        .map((item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
                latitude: item['loc_lat'],
                longtitude: item['loc_lng'],
                address: item['address'])))
        .toList();

    notifyListeners();
  }
}
